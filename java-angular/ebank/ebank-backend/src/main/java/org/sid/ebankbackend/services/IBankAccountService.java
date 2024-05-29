package org.sid.ebankbackend.services;

import org.sid.ebankbackend.entities.BankAccount;
import org.sid.ebankbackend.entities.CurrentAccount;
import org.sid.ebankbackend.entities.Customer;
import org.sid.ebankbackend.entities.SavingAccount;
import org.sid.ebankbackend.excecptions.BalanceNotSufficientException;
import org.sid.ebankbackend.excecptions.BankAccountNotFoundException;
import org.sid.ebankbackend.excecptions.CustomerNotFoundException;

import java.util.List;

public interface IBankAccountService {
    Customer saveCustomer(Customer customer);

    CurrentAccount saveCurrentBankAccount(double initialBalance, double overDraft, Long customerId) throws CustomerNotFoundException;

    SavingAccount saveSavingBankAccount(double initialBalance, double interestRate, Long customerId) throws CustomerNotFoundException;

    List<Customer> listCustomer();

    BankAccount getBankAccount(String accountId) throws BankAccountNotFoundException;

    void debit(String accountId, double amount, String description) throws BankAccountNotFoundException, BalanceNotSufficientException;

    void credit(String accountId, double amount, String description) throws BankAccountNotFoundException;

    void transfer(String accountIdSource, String accountIdDestination, double amount, String description) throws BankAccountNotFoundException, BalanceNotSufficientException;

    List<BankAccount> bankAccountList();
}
