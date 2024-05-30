package org.sid.ebankbackend.dtos;

import jakarta.persistence.*;
import lombok.Data;
import org.sid.ebankbackend.enums.OperationType;

import java.util.Date;

@Data
public class AccountOperationDTO {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Date operationDate;
    private double amount;
    private OperationType type;
    private String description;
}
