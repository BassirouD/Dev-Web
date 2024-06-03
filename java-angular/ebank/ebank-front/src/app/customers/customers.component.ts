import {Component, OnInit} from '@angular/core';
import {AsyncPipe, JsonPipe, NgForOf, NgIf} from "@angular/common";
import {CustomersService} from "../services/customers.service";
import {Customer} from "../models/customer.model";
import {catchError, map, Observable, throwError} from "rxjs";
import {FormBuilder, FormGroup, ReactiveFormsModule} from "@angular/forms";
import {Router} from "@angular/router";

@Component({
    selector: 'app-customers',
    standalone: true,
    imports: [
        NgForOf,
        NgIf,
        JsonPipe,
        AsyncPipe,
        ReactiveFormsModule
    ],
    templateUrl: './customers.component.html',
    styleUrl: './customers.component.css'
})
export class CustomersComponent implements OnInit {
    //customers!: Customer[]
    customers!: Observable<Customer[]>
    //errorMessage: string | undefined
    errorMessage!: ''
    searchFormGroup!: FormGroup


    constructor(private customerService: CustomersService, private fb: FormBuilder, private router: Router) {
    }

    ngOnInit(): void {
        this.searchFormGroup = this.fb.group({
            keyword: this.fb.control("")
        })
        this.handleSearchCustomer()
        /*
        this.customers = this.customerService.getCustomers().pipe(
            catchError(err => {
                this.errorMessage = err.message
                return throwError(() => new Error(`Invalid time ${err.message}`))
            })
        );
        ====================================
        this.customerService.getCustomers().subscribe({
          next: (data) => {
            this.customers = data;
          }, error: err => {
            this.errorMessage = err.message
            console.log(err)
          }
        })*/
    }

    handleSearchCustomer() {
        let keyword = this.searchFormGroup.value.keyword
        this.customers = this.customerService.searchCustomers(keyword).pipe(
            catchError(err => {
                this.errorMessage = err.error.message
                return throwError(() => new Error(err.message))
            })
        )

    }

    handleDeleteCustomer(customer: Customer) {
        let conf = confirm('Are you sure?')
        if (!conf) return;
        let id = customer.id
        this.customerService.deleteCustomer(id).subscribe({
            next: () => {
                this.customers = this.customers.pipe(
                    map(data => {
                        let index = data.indexOf(customer)
                        data.slice(index, 1)
                        return data;
                    })
                )
                //this.handleSearchCustomer();
                console.log('Delete')
            }, error: err => {
                console.log(err)
            }
        })
    }

    handleCustomerAccounts(customer: Customer) {
        this.router.navigateByUrl('/customer-account/' + customer.id, {state: customer})
    }
}
