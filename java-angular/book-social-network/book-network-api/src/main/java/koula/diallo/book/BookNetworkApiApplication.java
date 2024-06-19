package koula.diallo.book;

import koula.diallo.book.auth.AuthenticationService;
import koula.diallo.book.auth.RegistrationRequest;
import koula.diallo.book.role.Role;
import koula.diallo.book.role.RoleRepository;
import koula.diallo.book.user.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableJpaAuditing(auditorAwareRef = "auditorAware")
@EnableAsync
public class BookNetworkApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(BookNetworkApiApplication.class, args);
    }

    @Bean
    public CommandLineRunner runner(
            RoleRepository roleRepository,
            AuthenticationService service,
            UserRepository userRepository
    ) {
        return args -> {
            if (roleRepository.findByName("USER").isEmpty()) {
                roleRepository.save(
                        Role.builder()
                                .name("USER")
                                .build()
                );
            }
            if (roleRepository.findByName("ADMIN").isEmpty()) {
                roleRepository.save(
                        Role.builder()
                                .name("ADMIN")
                                .build()
                );
            }
            if (userRepository.findByEmail("admin@admin-bsn.fr").isEmpty()) {
                service.register(
                        RegistrationRequest.builder()
                                .firstname("ADMIN")
                                .lastname("ADMIN")
                                .email("admin@admin-bsn.fr")
                                .password("password11")
                                .build());
                var byEmail = userRepository.findByFirstname("ADMIN");
                var roles = roleRepository.findAll();
                byEmail.setEnable(true);
                byEmail.setRoles(roles);
                userRepository.save(byEmail);
            }
        };
    }

}
