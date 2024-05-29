package org.sid.ebankbackend.services;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.sid.ebankbackend.entities.*;
import org.sid.ebankbackend.enums.AccountStatus;
import org.sid.ebankbackend.enums.OperationType;
import org.sid.ebankbackend.excecptions.BalanceNotSufficientException;
import org.sid.ebankbackend.excecptions.BankAccountNotFoundException;
import org.sid.ebankbackend.excecptions.CustomerNotFoundException;
import org.sid.ebankbackend.repositories.AccountOperationRepository;
import org.sid.ebankbackend.repositories.BankAccountRepository;
import org.sid.ebankbackend.repositories.CustomerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
@AllArgsConstructor
@Slf4j
public class BankAccountServiceImpl implements IBankAccountService {
    private CustomerRepository customerRepository;
    private BankAccountRepository bankAccountRepository;
    private AccountOperationRepository accountOperationRepository;

    //Logger log = LoggerFactory.getLogger(this.getClass().getName());

    @Override
    public Customer saveCustomer(Customer customer) {
        Customer savedCustomer = customerRepository.save(customer);
        log.info("Saving new customer at " + new Date());
        return savedCustomer;
    }

    @Override
    public CurrentAccount saveCurrentBankAccount(double initialBalance, double overDraft, Long customerId) throws CustomerNotFoundException {
        Customer customer = customerRepository.findById(customerId).orElse(null);
        if (customer == null)
            throw new CustomerNotFoundException("Customer not found");
        CurrentAccount currentAccount = new CurrentAccount();
        currentAccount.setId(UUID.randomUUID().toString());
        currentAccount.setCreatedAt(new Date());
        currentAccount.setBalance(initialBalance);
        currentAccount.setCustomer(customer);
        currentAccount.setStatus(AccountStatus.CREATED);
        currentAccount.setCurrency("US");
        currentAccount.setOverDraft(overDraft);
        CurrentAccount savedBankAccount = bankAccountRepository.save(currentAccount);

        return savedBankAccount;
    }

    @Override
    public SavingAccount saveSavingBankAccount(double initialBalance, double interestRate, Long customerId) throws CustomerNotFoundException {
        Customer customer = customerRepository.findById(customerId).orElse(null);
        if (customer == null)
            throw new CustomerNotFoundException("Customer not found");
        SavingAccount savingAccount = new SavingAccount();
        savingAccount.setId(UUID.randomUUID().toString());
        savingAccount.setCreatedAt(new Date());
        savingAccount.setBalance(initialBalance);
        savingAccount.setCustomer(customer);
        savingAccount.setStatus(AccountStatus.CREATED);
        savingAccount.setCurrency("US");
        savingAccount.setInterestRate(interestRate);
        SavingAccount savedBankAccount = bankAccountRepository.save(savingAccount);
        return savedBankAccount;
    }

    @Override
    public List<Customer> listCustomer() {
        return customerRepository.findAll();
    }

    @Override
    public BankAccount getBankAccount(String accountId) throws BankAccountNotFoundException {
        BankAccount bankAccount = bankAccountRepository.findById(accountId)
                .orElseThrow(() -> new BankAccountNotFoundException("Bank account not found"));
        return bankAccount;
    }

    @Override
    public void debit(String accountId, double amount, String description) throws BankAccountNotFoundException, BalanceNotSufficientException {
        BankAccount bankAccount = getBankAccount(accountId);
        if (bankAccount.getBalance() < amount)
            throw new BalanceNotSufficientException("Balance not sufficient");
        AccountOperation accountOperation = new AccountOperation();
        accountOperation.setType(OperationType.DEBIT);
        accountOperation.setAmount(amount);
        accountOperation.setDescription(description);
        accountOperation.setOperationDate(new Date());
        accountOperation.setBankAccount(bankAccount);
        accountOperationRepository.save(accountOperation);
        bankAccount.setBalance(bankAccount.getBalance() - amount);
        bankAccountRepository.save(bankAccount);

    }

    @Override
    public void credit(String accountId, double amount, String description) throws BankAccountNotFoundException {
        BankAccount bankAccount = getBankAccount(accountId);
        AccountOperation accountOperation = new AccountOperation();
        accountOperation.setType(OperationType.CREDIT);
        accountOperation.setAmount(amount);
        accountOperation.setDescription(description);
        accountOperation.setOperationDate(new Date());
        accountOperation.setBankAccount(bankAccount);
        accountOperationRepository.save(accountOperation);
        bankAccount.setBalance(bankAccount.getBalance() + amount);
        bankAccountRepository.save(bankAccount);
        log.info("Operation credit don with description " + description);
    }

    @Override
    public void transfer(String accountIdSource, String accountIdDestination, double amount, String description) throws BankAccountNotFoundException, BalanceNotSufficientException {
        debit(accountIdSource, amount, description);
        credit(accountIdDestination, amount, description);
        log.info("Tranfer from " + accountIdSource + " to " + accountIdDestination + " done with the amount " + amount + " at " + new Date());
    }

    @Override
    public List<BankAccount> bankAccountList() {
        return bankAccountRepository.findAll();
    }
}
