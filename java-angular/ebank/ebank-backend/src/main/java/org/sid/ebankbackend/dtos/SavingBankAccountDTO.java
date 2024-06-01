package org.sid.ebankbackend.dtos;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.sid.ebankbackend.entities.AccountOperation;
import org.sid.ebankbackend.entities.Customer;
import org.sid.ebankbackend.enums.AccountStatus;

import java.util.Date;
import java.util.List;


@Data
public class SavingBankAccountDTO extends BankAccountDTO{
    private double interestRate;
}
