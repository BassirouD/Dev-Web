package koula.diallo.backendspring.repositories;

import koula.diallo.backendspring.entities.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StudentRepo extends JpaRepository<Student, String> {
    Student findByCode(String code);

    List<Student> findByProgramId(String id);
}
