package org.sid.ebankbackend.web;

import lombok.AllArgsConstructor;
import org.sid.ebankbackend.dtos.BankAccountDTO;
import org.sid.ebankbackend.excecptions.BankAccountNotFoundException;
import org.sid.ebankbackend.services.IBankAccountService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@AllArgsConstructor
public class BankAccountController {
    private IBankAccountService bankAccountService;

    @GetMapping("/accounts/{accountId}")
    public BankAccountDTO getBankAccount(@PathVariable String accountId) throws BankAccountNotFoundException {
        return bankAccountService.getBankAccount(accountId);
    }

    @GetMapping("/accounts")
    public List<BankAccountDTO> listAccount() {
        return bankAccountService.bankAccountList();
    }

}
