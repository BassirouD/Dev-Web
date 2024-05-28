package org.sid.ebankbackend.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    /**
     * Le mappedBy c'est pour dire qu'il s'agit de la meme relation(dans la classe BankAccount)
     * Sinon JPA va tanter de créer deux clés étrangères
     */
    @OneToMany(mappedBy = "customer")
    private List<BankAccount> bankAccounts;
}
