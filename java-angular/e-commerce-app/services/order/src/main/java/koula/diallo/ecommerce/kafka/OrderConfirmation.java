package koula.diallo.ecommerce.kafka;

import koula.diallo.ecommerce.customer.CustomerResponse;
import koula.diallo.ecommerce.order.PaymentMethod;
import koula.diallo.ecommerce.product.PurchaseResponse;

import java.math.BigDecimal;
import java.util.List;

public record OrderConfirmation(
        String orderReference,
        BigDecimal totalAmount,
        PaymentMethod paymentMethod,
        CustomerResponse customer,
        List<PurchaseResponse> products
) {
}
