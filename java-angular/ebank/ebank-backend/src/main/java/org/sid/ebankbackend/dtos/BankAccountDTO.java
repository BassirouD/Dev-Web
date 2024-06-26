package org.sid.ebankbackend.dtos;

import lombok.Data;
import org.sid.ebankbackend.enums.AccountStatus;

import java.util.Date;

@Data
public class BankAccountDTO {
    private String id;
    private double balance;
    private Date createdAt;
    private AccountStatus status;
    private String Currency;
    private CustomerDTO customerDTO;
    private String type;
}
