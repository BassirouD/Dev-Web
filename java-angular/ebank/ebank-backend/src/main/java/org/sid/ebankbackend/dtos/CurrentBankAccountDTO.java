package org.sid.ebankbackend.dtos;

import lombok.Data;
import org.sid.ebankbackend.enums.AccountStatus;

import java.util.Date;


@Data
public class CurrentBankAccountDTO extends BankAccountDTO{
    private double overDraft;
}
