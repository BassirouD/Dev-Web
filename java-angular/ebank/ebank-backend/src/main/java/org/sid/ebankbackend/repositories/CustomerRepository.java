package org.sid.ebankbackend.repositories;

import org.sid.ebankbackend.entities.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
    List<Customer> findByNameContaining(String keyword);
    //OU
    @Query("select c from Customer c where c.name like :kc")
    List<Customer> searchCustomer(@Param("kc") String keyword);
}
