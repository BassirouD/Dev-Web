package org.sid.ebankbackend.entities;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UuidGenerator;
import org.sid.ebankbackend.enums.AccountStatus;
import java.util.Date;
import java.util.List;

/**
 * Pour l'heritage(mapping heritage), 3 strategie:
 * 1) Single Table:
 *      Dans cette partie, tous les attributs dans la mm table(mm ceux des classes filles)
 *      et en plus d'un champ type(Discriminator Column) pour différencier les classes filles.
 *      Donc y'aura des champs null(trou dans la base, pas ouf pour la mémoire)
 *      mais elle est plus performante(Du fait que c une seule table)
 * 2) Table Per Class
 *      Séparation des tables. Avantage: Pas de trous dans la table et inconvenients: recherches sur
 *      plusieurs tables, pas ouf coté performance, répétition de la mm structure des tables.
 *      Donc on l'utilise quand y'a une grande diff entre les tables
 * 3) Joined Table
 *      On crée 3 tables:
 *      -   Une pour les champs communs, BankAccount par exemple
 *      -   Les 2 autres, chaqu'une garde ses attributs specifiques
 *          par exemple CurrentAccount(overDraft, id_BankAccount) et SavingAccount(interestRate, id_BankAccount)
 *          Le id_BankAccount c pour linker les tables: table(BankAccount) ------> CurrentAccount et SavingAccount
 */

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "TYPE", length = 4, discriminatorType = DiscriminatorType.STRING)
public class BankAccount {
    @Id
    private String id;
    private double balance;//Le solde
    private Date createdAt;
    private AccountStatus status;
    private String Currency;
    @ManyToOne
    private Customer customer;
    @OneToMany(mappedBy = "bankAccount")
    private List<AccountOperation> accountOperations;
}
