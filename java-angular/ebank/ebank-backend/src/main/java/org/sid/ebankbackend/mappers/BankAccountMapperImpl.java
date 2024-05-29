package org.sid.ebankbackend.mappers;

import org.sid.ebankbackend.dtos.CustomerDTO;
import org.sid.ebankbackend.entities.Customer;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

/**
 * On peut utiliser aussi MapStruct(un framework)
 */
@Service
public class BankAccountMapperImpl {
    public CustomerDTO fromCustomer(Customer customer) {
        CustomerDTO customerDTO = new CustomerDTO();
        BeanUtils.copyProperties(customer, customerDTO);
        /**
         * C'est la mm chose que #BeanUtils.copyProperties(customer, customerDTO);
         customerDTO.setEmail(customer.getEmail());
         customerDTO.setId(customer.getId());
         customerDTO.setName(customer.getName());
         */
        return customerDTO;
    }

    public Customer fromCustomerDTO(CustomerDTO customerDTO) {
        Customer customer = new Customer();
        BeanUtils.copyProperties(customerDTO, customer);
        return customer;
    }
}
