package koula.diallo.book.user;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    User findByFirstname(String email);

    @Query("""
                 SELECT user
                 FROM User user
                 WHERE user.id != :userId
            """)
    Page<User> findAllUsers(Pageable pageable, Integer userId);
}
