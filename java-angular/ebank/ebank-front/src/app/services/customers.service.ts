import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Customer} from "../models/customer.model";

@Injectable({
    providedIn: 'root'
})
export class CustomersService {
    private apiUrl = 'http://localhost:8085';

    constructor(private http: HttpClient) {
    }

    getCustomers() {
        return this.http.get<Array<Customer>>(this.apiUrl + '/customers');
    }

    searchCustomers(keyword: string) {
        return this.http.get<Array<Customer>>(this.apiUrl + '/customers/search?keyword=' + keyword);
    }

    saveCustomer(customer: Customer) {
        return this.http.post<Customer>(this.apiUrl + '/customers', customer);
    }

    deleteCustomer(id: number) {
        return this.http.delete(this.apiUrl + '/customers/' + id)
    }
}
