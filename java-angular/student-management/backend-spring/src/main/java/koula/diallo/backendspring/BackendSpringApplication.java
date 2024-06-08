package koula.diallo.backendspring;

import koula.diallo.backendspring.entities.Payment;
import koula.diallo.backendspring.entities.PaymentStatus;
import koula.diallo.backendspring.entities.PaymentType;
import koula.diallo.backendspring.entities.Student;
import koula.diallo.backendspring.repositories.PaymentRepo;
import koula.diallo.backendspring.repositories.StudentRepo;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Random;
import java.util.UUID;

@SpringBootApplication
public class BackendSpringApplication {

    public static void main(String[] args) {
        SpringApplication.run(BackendSpringApplication.class, args);
    }

    @Bean
    CommandLineRunner commandLineRunner(StudentRepo studentRepo, PaymentRepo paymentRepo) {
        return args -> {
            studentRepo.save(Student.builder()
                    .id(UUID.randomUUID().toString())
                    .firstName("Abou")
                    .lastName("Sy")
                    .code("1231")
                    .programId("INFO")
                    .build());
            studentRepo.save(Student.builder()
                    .id(UUID.randomUUID().toString())
                    .firstName("Aliou")
                    .lastName("Ba")
                    .code("1232")
                    .programId("INFO")
                    .build());
            studentRepo.save(Student.builder()
                    .id(UUID.randomUUID().toString())
                    .firstName("Karima")
                    .lastName("Diallo")
                    .code("1233")
                    .programId("INFO")
                    .build());
            studentRepo.save(Student.builder()
                    .id(UUID.randomUUID().toString())
                    .firstName("Mohamed")
                    .lastName("Gueye")
                    .code("1244")
                    .programId("SOCIO")
                    .build());

            PaymentType[] paymentType = PaymentType.values();
            Random random = new Random();
            studentRepo.findAll().forEach(student -> {
                for (int i = 0; i < 10; i++) {
                    int index = random.nextInt(paymentType.length);
                    Payment payment = Payment.builder()
                            .amount(1000 + (int) (Math.random() * 20000))
                            .paymentType(paymentType[index])
                            .paymentStatus(PaymentStatus.CREATED)
                            .student(student)
                            .build();
                    paymentRepo.save(payment);
                }
            });
        };
    }

}
