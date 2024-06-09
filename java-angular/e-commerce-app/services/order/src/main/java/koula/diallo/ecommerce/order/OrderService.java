package koula.diallo.ecommerce.order;

import jakarta.persistence.EntityNotFoundException;
import koula.diallo.ecommerce.customer.CustomerClient;
import koula.diallo.ecommerce.exceptions.BusinessException;
import koula.diallo.ecommerce.kafka.OrderConfirmation;
import koula.diallo.ecommerce.kafka.OrderProducer;
import koula.diallo.ecommerce.orderline.OrderLineRequest;
import koula.diallo.ecommerce.orderline.OrderLineService;
import koula.diallo.ecommerce.product.ProductClient;
import koula.diallo.ecommerce.product.PurchaseRequest;
import koula.diallo.ecommerce.product.PurchaseResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final CustomerClient customerClient;
    private final ProductClient productClient;
    private final OrderRepository repository;
    private final OrderMapper mapper;
    private final OrderLineService orderLineService;
    private final OrderProducer orderProducer;

    public Integer createOrder(OrderRequest request) {
        //Check the customer --> OpenFeign
        var customer = customerClient.findCustomerById(request.customerId())
                .orElseThrow(() -> new BusinessException("Cannot create order:: No customer exist with the provided ID:: " + request.customerId()));

        //purchase the products --> product-micro-service(RestTemplate)
        List<PurchaseResponse> purchaseProducts = productClient.purchaseProducts(request.products());

        //persist the order lines
        var order = repository.save(mapper.toOrder(request));
        for (PurchaseRequest purchaseRequest : request.products()) {
            orderLineService.saveOrderLine(
                    new OrderLineRequest(
                            null,
                            order.getId(),
                            purchaseRequest.productId(),
                            purchaseRequest.quantity()
                    )
            );
        }
        // todo start the payment process

        //send the order confirmation --> notification-micro-service(kafka)
        orderProducer.sendOrderConfirmation(
                new OrderConfirmation(
                        request.reference(),
                        request.amount(),
                        request.paymentMethod(),
                        customer,
                        purchaseProducts
                )
        );
        return order.getId();
    }

    public List<OrderResponse> findAll() {
        return repository.findAll().stream()
                .map(mapper::fromOrder)
                .collect(Collectors.toList());
    }

    public OrderResponse findById(Integer orderId) {
        return repository.findById(orderId)
                .map(mapper::fromOrder)
                .orElseThrow(() -> new EntityNotFoundException(String.format("No order found with the provided ID: $d", orderId)));
    }

}
