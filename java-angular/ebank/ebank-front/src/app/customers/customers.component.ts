import {Component, OnInit} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {AsyncPipe, JsonPipe, NgForOf, NgIf} from "@angular/common";
import {CustomersService} from "../services/customers.service";
import {Customer} from "../models/customer.model";
import {catchError, Observable, throwError} from "rxjs";

@Component({
  selector: 'app-customers',
  standalone: true,
  imports: [
    NgForOf,
    NgIf,
    JsonPipe,
    AsyncPipe
  ],
  templateUrl: './customers.component.html',
  styleUrl: './customers.component.css'
})
export class CustomersComponent implements OnInit {
  //customers!: Customer[]
  customers!: Observable<Customer[]>
  //errorMessage: string | undefined
  errorMessage!: object


  constructor(private customerService: CustomersService) {
  }

  ngOnInit(): void {
    this.customers = this.customerService.getCustomers().pipe(
      catchError(err => {
        this.errorMessage=err.message
        return throwError(() => new Error(`Invalid time ${ err.message }`))
      })
    );
    /*this.customerService.getCustomers().subscribe({
      next: (data) => {
        this.customers = data;
      }, error: err => {
        this.errorMessage = err.message
        console.log(err)
      }
    })*/
  }
}
