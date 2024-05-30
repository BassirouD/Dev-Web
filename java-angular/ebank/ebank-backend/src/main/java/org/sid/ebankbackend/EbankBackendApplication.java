package org.sid.ebankbackend;

import org.sid.ebankbackend.dtos.BankAccountDTO;
import org.sid.ebankbackend.dtos.CurrentBankAccountDTO;
import org.sid.ebankbackend.dtos.CustomerDTO;
import org.sid.ebankbackend.dtos.SavingBankAccountDTO;
import org.sid.ebankbackend.entities.*;
import org.sid.ebankbackend.enums.AccountStatus;
import org.sid.ebankbackend.enums.OperationType;
import org.sid.ebankbackend.excecptions.BalanceNotSufficientException;
import org.sid.ebankbackend.excecptions.BankAccountNotFoundException;
import org.sid.ebankbackend.excecptions.CustomerNotFoundException;
import org.sid.ebankbackend.repositories.AccountOperationRepository;
import org.sid.ebankbackend.repositories.BankAccountRepository;
import org.sid.ebankbackend.repositories.CustomerRepository;
import org.sid.ebankbackend.services.BankAccountServiceImpl;
import org.sid.ebankbackend.services.IBankAccountService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Stream;

@SpringBootApplication
public class EbankBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(EbankBackendApplication.class, args);
    }

    @Bean
    CommandLineRunner commandLineRunner(IBankAccountService bankAccountService) {
        return args -> {
            Stream.of("Hassatou", "Aicha", "Duaa", "Henriette").forEach(name -> {
                CustomerDTO customer = new CustomerDTO();
                customer.setName(name);
                customer.setEmail(name + "gmail.fr");
                bankAccountService.saveCustomer(customer);
            });
            bankAccountService.listCustomer().forEach(customer -> {
                try {
                    bankAccountService.saveCurrentBankAccount(Math.random() * 9000, 9000, customer.getId());
                    bankAccountService.saveSavingBankAccount(Math.random() * 9000, 5.5, customer.getId());
                    List<BankAccountDTO> bankAccountList = bankAccountService.bankAccountList();
                    for (BankAccountDTO bankAccount : bankAccountList) {
                        String accountId;
                        if (bankAccount instanceof SavingBankAccountDTO) {
                            accountId = ((SavingBankAccountDTO) bankAccount).getId();
                        }else {
                            accountId=((CurrentBankAccountDTO) bankAccount).getId();
                        }
                        bankAccountService.credit(accountId, Math.random() * 12000, "Credit to " + accountId);
                        bankAccountService.debit(accountId, Math.random() * 1000, "Debit to " + accountId);
                    }

                } catch (CustomerNotFoundException | BankAccountNotFoundException | BalanceNotSufficientException e) {
                    e.printStackTrace();
                }
            });
        };
    }

    CommandLineRunner start(CustomerRepository customerRepository, AccountOperationRepository accountOperationRepository, BankAccountRepository bankAccountRepository) {
        return args -> {
            Stream.of("Hassan", "Aicha", "Duaa", "Henriette").forEach(name -> {
                Customer customer = new Customer();
                customer.setName(name);
                customer.setEmail(name + "@gmail.fr");
                customerRepository.save(customer);
            });
            customerRepository.findAll().forEach(customer -> {
                CurrentAccount currentAccount = new CurrentAccount();
                currentAccount.setId(UUID.randomUUID().toString());
                currentAccount.setCurrency("US");
                currentAccount.setBalance(Math.random() * 90000);
                currentAccount.setCreatedAt(new Date());
                currentAccount.setStatus(AccountStatus.CREATED);
                currentAccount.setCustomer(customer);
                currentAccount.setOverDraft(90000);
                bankAccountRepository.save(currentAccount);
            });

            customerRepository.findAll().forEach(customer -> {
                SavingAccount savingAccount = new SavingAccount();
                savingAccount.setId(UUID.randomUUID().toString());
                savingAccount.setBalance(Math.random() * 90000);
                savingAccount.setCurrency("US");
                savingAccount.setCreatedAt(new Date());
                savingAccount.setStatus(AccountStatus.CREATED);
                savingAccount.setCustomer(customer);
                savingAccount.setInterestRate(5.5);
                bankAccountRepository.save(savingAccount);
            });

            bankAccountRepository.findAll().forEach(bankAccount -> {
                for (int i = 0; i < 10; i++) {
                    AccountOperation accountOperation = new AccountOperation();
                    accountOperation.setOperationDate(new Date());
                    accountOperation.setAmount(Math.random() * 12000);
                    accountOperation.setType(Math.random() > 0.5 ? OperationType.DEBIT : OperationType.CREDIT);
                    accountOperation.setBankAccount(bankAccount);
                    accountOperationRepository.save(accountOperation);
                }
            });
        };
    }

}
