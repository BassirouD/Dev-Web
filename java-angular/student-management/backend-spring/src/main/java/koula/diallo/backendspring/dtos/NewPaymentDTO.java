package koula.diallo.backendspring.dtos;

import koula.diallo.backendspring.entities.PaymentStatus;
import koula.diallo.backendspring.entities.PaymentType;
import lombok.*;

import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NewPaymentDTO {
    private double amount;
    private PaymentType paymentType;
    private LocalDate date;
    private String studentCode;
}
