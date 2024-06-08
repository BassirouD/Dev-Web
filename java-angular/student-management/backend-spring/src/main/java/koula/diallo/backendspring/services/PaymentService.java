package koula.diallo.backendspring.services;

import koula.diallo.backendspring.entities.Payment;
import koula.diallo.backendspring.entities.PaymentStatus;
import koula.diallo.backendspring.entities.PaymentType;
import koula.diallo.backendspring.entities.Student;
import koula.diallo.backendspring.repositories.PaymentRepo;
import koula.diallo.backendspring.repositories.StudentRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
public class PaymentService {
    private final StudentRepo studentRepo;
    private final PaymentRepo paymentRepo;

    public Payment savePayment(MultipartFile file, LocalDate date, double amount, PaymentType paymentType, String studentCode) throws IOException {
        Path folderPath = Paths.get(System.getProperty("user.home"), "students-data", "payments");
        if (!Files.exists(folderPath)) {
            Files.createDirectories(folderPath);
        }
        String fileName = UUID.randomUUID().toString();
        Path filePath = Paths.get(System.getProperty("user.home"), "students-data", "payments", fileName + ".pdf");
        Files.copy(file.getInputStream(), filePath);
        Student student = studentRepo.findByCode(studentCode);
        Payment payment = Payment.builder()
                .date(date)
                .paymentType(paymentType)
                .student(student)
                .amount(amount)
                .file(filePath.toUri().toString())
                .paymentStatus(PaymentStatus.CREATED)
                .build();
        return paymentRepo.save(payment);
    }

    public Payment updatePaymentStatus(PaymentStatus paymentStatus, Long id) {
        Payment payment = paymentRepo.findById(id).get();
        payment.setPaymentStatus(paymentStatus);
        return paymentRepo.save(payment);
    }

    public byte[] getPaymentFile(Long paymentId) throws IOException {
        Payment payment = paymentRepo.findById(paymentId).get();
        return Files.readAllBytes(Path.of(URI.create(payment.getFile())));
    }
}
