package koula.diallo.ecommerce.payment;

import koula.diallo.ecommerce.customer.CustomerResponse;
import koula.diallo.ecommerce.order.PaymentMethod;

import java.math.BigDecimal;

public record PaymentRequest(
        BigDecimal amount,
        PaymentMethod paymentMethod,
        Integer orderId,
        String orderReference,
        CustomerResponse customer
) {
}
