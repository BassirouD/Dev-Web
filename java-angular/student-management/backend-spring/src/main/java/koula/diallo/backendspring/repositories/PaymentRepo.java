package koula.diallo.backendspring.repositories;

import koula.diallo.backendspring.entities.Payment;
import koula.diallo.backendspring.entities.PaymentStatus;
import koula.diallo.backendspring.entities.PaymentType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepo extends JpaRepository<Payment, Long> {
    List<Payment> findByStudentCode(String code);

    List<Payment> findByPaymentStatus(PaymentStatus paymentStatus);

    List<Payment> findByPaymentType(PaymentType paymentType);
}
