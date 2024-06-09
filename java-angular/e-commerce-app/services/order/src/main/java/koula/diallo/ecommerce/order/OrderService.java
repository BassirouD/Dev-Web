package koula.diallo.ecommerce.order;

import koula.diallo.ecommerce.customer.CustomerClient;
import koula.diallo.ecommerce.exceptions.BusinessException;
import koula.diallo.ecommerce.orderline.OrderLineRequest;
import koula.diallo.ecommerce.orderline.OrderLineService;
import koula.diallo.ecommerce.product.ProductClient;
import koula.diallo.ecommerce.product.PurchaseRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final CustomerClient customerClient;
    private final ProductClient productClient;
    private final OrderRepository repository;
    private final OrderMapper mapper;
    private final OrderLineService orderLineService;

    public Integer createOrder(OrderRequest request) {
        //Check the customer --> OpenFeign
        var customer = customerClient.findCustomerById(request.customerId())
                .orElseThrow(() -> new BusinessException("Cannot create order:: No customer exist with the provided ID:: " + request.customerId()));

        //purchase the products --> product-micro-service(RestTemplate)
        productClient.purchaseProducts(request.products());

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

        return null;
    }
}
