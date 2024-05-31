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
}
