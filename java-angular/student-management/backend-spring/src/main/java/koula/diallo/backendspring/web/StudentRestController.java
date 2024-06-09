package koula.diallo.backendspring.web;

import koula.diallo.backendspring.entities.Payment;
import koula.diallo.backendspring.entities.Student;
import koula.diallo.backendspring.repositories.PaymentRepo;
import koula.diallo.backendspring.repositories.StudentRepo;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@CrossOrigin("*")
@RestController
@AllArgsConstructor
public class StudentRestController {
    private StudentRepo studentRepo;
    private PaymentRepo paymentRepo;


    @GetMapping(path = "/students")
    public List<Student> allStudents() {
        return studentRepo.findAll();
    }

    @GetMapping(path = "/students/{code}")
    public Student getStudentByCode(@PathVariable String code) {
        return studentRepo.findByCode(code);
    }

    @GetMapping(path = "/studentsProgramId")
    public List<Student> getStudentsByProgramId(@RequestParam String programId) {
        return studentRepo.findByProgramId(programId);
    }

    @GetMapping(path = "/students/{code}/payments")
    public List<Payment> paymentsStudent(@PathVariable String code) {
        return paymentRepo.findByStudentCode(code);
    }


}
