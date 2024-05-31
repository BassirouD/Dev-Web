import {Component, OnInit} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {JsonPipe, NgForOf, NgIf} from "@angular/common";
import {CustomersService} from "../services/customers.service";
import {Customer} from "../models/customer.model";

@Component({
  selector: 'app-customers',
  standalone: true,
  imports: [
    NgForOf,
    NgIf,
    JsonPipe
  ],
  templateUrl: './customers.component.html',
  styleUrl: './customers.component.css'
})
export class CustomersComponent implements OnInit {
  customers!: Customer[]
  //errorMessage: string | undefined
  errorMessage!: object


  constructor(private customerService: CustomersService) {
  }

  ngOnInit(): void {
    this.customerService.getCustomers().subscribe({
      next: (data) => {
        this.customers = data;
      }, error: err => {
        this.errorMessage = err.message
        console.log(err)
      }
    })
  }
}
