package koula.diallo.backendspring.web;

import koula.diallo.backendspring.dtos.NewPaymentDTO;
import koula.diallo.backendspring.entities.Payment;
import koula.diallo.backendspring.entities.PaymentStatus;
import koula.diallo.backendspring.entities.PaymentType;
import koula.diallo.backendspring.repositories.PaymentRepo;
import koula.diallo.backendspring.services.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@CrossOrigin("*")
@RestController
@RequiredArgsConstructor
public class PaymentRestController {
    private final PaymentRepo paymentRepo;
    private final PaymentService paymentService;

    @GetMapping(path = "/payments")
    public List<Payment> allPayments() {
        return paymentRepo.findAll();
    }

    @GetMapping(path = "/payments/{id}")
    public Payment getPaymentById(@PathVariable Long id) {
        return paymentRepo.findById(id).get();
    }

    @GetMapping(path = "/payments/byStatus")
    public List<Payment> paymentsByStatus(@RequestParam PaymentStatus paymentStatus) {
        return paymentRepo.findByPaymentStatus(paymentStatus);
    }

    @GetMapping(path = "/payments/byType")
    public List<Payment> paymentsByType(@RequestParam PaymentType paymentType) {
        return paymentRepo.findByPaymentType(paymentType);
    }

    @PutMapping("/payments/{id}")
    public Payment updatePaymentStatus(
            @RequestParam PaymentStatus paymentStatus,
            @PathVariable Long id) {
        return paymentService.updatePaymentStatus(paymentStatus, id);
    }

    @PostMapping(path = "/payments", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Payment savePayment(
            @RequestParam("file") MultipartFile file, NewPaymentDTO newPaymentDTO) throws IOException {
        return paymentService.savePayment(file, newPaymentDTO);
    }

    @GetMapping(path = "/paymentFile/{paymentId}", produces = MediaType.APPLICATION_PDF_VALUE)
    public byte[] getPaymentFile(@PathVariable Long paymentId) throws IOException {
        return paymentService.getPaymentFile(paymentId);
    }

}
