import {Component, OnInit} from '@angular/core';
import {ActivatedRoute, Router} from "@angular/router";
import {Customer} from "../models/customer.model";
import {AccountsService} from "../services/accounts.service";
import {Account} from "../models/accountInfo.model";
import {AsyncPipe, DatePipe, DecimalPipe, NgForOf} from "@angular/common";

@Component({
    selector: 'app-customer-account',
    standalone: true,
    imports: [
        AsyncPipe,
        NgForOf,
        DatePipe,
        DecimalPipe
    ],
    templateUrl: './customer-account.component.html',
    styleUrl: './customer-account.component.css'
})
export class CustomerAccountComponent implements OnInit {
    customerId!: number;
    customer!: Customer;
    accountsCustomer!: Account[]

    constructor(private route: ActivatedRoute,
                private router: Router, private accountSrv: AccountsService) {
        this.customer = this.router.getCurrentNavigation()?.extras.state as Customer;
    }

    ngOnInit(): void {
        this.customerId = this.route.snapshot.params['id'];
        this.getAccountsCustomer(this.customerId)
    }

    getAccountsCustomer(customerId: number) {
        this.accountSrv.getAccountsCustomer(customerId).subscribe({
            next: value => {
                this.accountsCustomer = value
                console.log(value)
            }, error: err => {
                console.log(err)
            }
        })
    }

}
