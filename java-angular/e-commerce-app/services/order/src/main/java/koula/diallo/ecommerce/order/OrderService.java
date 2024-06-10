package koula.diallo.ecommerce.order;

import jakarta.persistence.EntityNotFoundException;
import koula.diallo.ecommerce.customer.CustomerClient;
import koula.diallo.ecommerce.exceptions.BusinessException;
import koula.diallo.ecommerce.kafka.OrderConfirmation;
import koula.diallo.ecommerce.kafka.OrderProducer;
import koula.diallo.ecommerce.orderline.OrderLineRequest;
import koula.diallo.ecommerce.orderline.OrderLineService;
import koula.diallo.ecommerce.payment.PaymentClient;
import koula.diallo.ecommerce.payment.PaymentRequest;
import koula.diallo.ecommerce.product.ProductClient;
import koula.diallo.ecommerce.product.PurchaseRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository repository;
    private final OrderMapper mapper;
    private final CustomerClient customerClient;
    private final PaymentClient paymentClient;
    private final ProductClient productClient;
    private final OrderLineService orderLineService;
    private final OrderProducer orderProducer;

    @Transactional
    public Integer createOrder(OrderRequest request) {
        //Check the customer --> OpenFeign
        var customer = this.customerClient.findCustomerById(request.customerId())
                .orElseThrow(() -> new BusinessException("Cannot create order:: No customer exists with the provided ID"));

        //purchase the products --> product-micro-service(RestTemplate)
        var purchasedProducts = productClient.purchaseProducts(request.products());

        // todo persist the order lines
        var order = this.repository.save(mapper.toOrder(request));
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
        var paymentRequest = new PaymentRequest(
                request.amount(),
                request.paymentMethod(),
                order.getId(),
                order.getReference(),
                customer
        );
        paymentClient.requestOrderPayment(paymentRequest);

        // todo send the order confirmation --> notification-micro-service(kafka)
        orderProducer.sendOrderConfirmation(
                new OrderConfirmation(
                        request.reference(),
                        request.amount(),
                        request.paymentMethod(),
                        customer,
                        purchasedProducts
                )
        );

        return order.getId();
    }

    public List<OrderResponse> findAllOrders() {
        return this.repository.findAll()
                .stream()
                .map(this.mapper::fromOrder)
                .collect(Collectors.toList());
    }

    public OrderResponse findById(Integer id) {
        return this.repository.findById(id)
                .map(this.mapper::fromOrder)
                .orElseThrow(() -> new EntityNotFoundException(String.format("No order found with the provided ID: %d", id)));
    }
}