package gn.koula.admissionplusapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableJpaAuditing(auditorAwareRef = "auditorAware")
@EnableAsync
public class AdmissionPlusApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(AdmissionPlusApiApplication.class, args);
    }

}
