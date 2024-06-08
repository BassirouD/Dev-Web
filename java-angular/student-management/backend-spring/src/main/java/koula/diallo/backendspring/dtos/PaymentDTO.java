package koula.diallo.backendspring.dtos;

import koula.diallo.backendspring.entities.PaymentStatus;
import koula.diallo.backendspring.entities.PaymentType;
import lombok.*;
import java.time.LocalDate;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class PaymentDTO {
    private Long id;
    private LocalDate date;
    private double amount;
    private PaymentType paymentType;
    private PaymentStatus paymentStatus;
}
