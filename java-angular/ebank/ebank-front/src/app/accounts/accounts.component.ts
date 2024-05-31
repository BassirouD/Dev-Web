import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, ReactiveFormsModule} from "@angular/forms";
import {AccountsService} from "../services/accounts.service";
import {Observable} from "rxjs";
import {AccountDetails} from "../models/account.model";
import {AsyncPipe, DatePipe, DecimalPipe, NgClass, NgForOf, NgIf} from "@angular/common";

@Component({
    selector: 'app-accounts',
    standalone: true,
    imports: [
        ReactiveFormsModule,
        NgIf,
        AsyncPipe,
        DecimalPipe,
        NgForOf,
        DatePipe,
        NgClass
    ],
    templateUrl: './accounts.component.html',
    styleUrl: './accounts.component.css'
})
export class AccountsComponent implements OnInit {
    accountFormGroup!: FormGroup
    operationFormGroup!: FormGroup
    currentPage: number = 0;
    pageSize: number = 5
    accountObservable$!: Observable<AccountDetails>;

    constructor(private fb: FormBuilder, private accountService: AccountsService) {
    }

    ngOnInit(): void {
        this.accountFormGroup = this.fb.group({
            accountId: ['']
        })
        this.operationFormGroup = this.fb.group({
            operationType: [''],
            amount: [0],
            description: [''],
            accountDestination: [''],
        })
    }

    handleSearchAccount() {
        let accountId = this.accountFormGroup.value.accountId
        this.accountObservable$ = this.accountService.getAccount(accountId, this.currentPage, this.pageSize)
    }

    goToPage(page: number) {
        this.currentPage = page;
        this.handleSearchAccount();
    }

    handleAccountOperation() {
        let accountId = this.accountFormGroup.value.accountId;
        let accountDestination = this.operationFormGroup.value.accountDestination;
        let amount = this.operationFormGroup.value.amount;
        let description = this.operationFormGroup.value.description;
        let operationType = this.operationFormGroup.value.operationType;
        if (operationType == 'DEBIT') {
            this.accountService.debit(accountId, amount, description).subscribe({
                next: (data) => {
                    alert('Success debit')
                    this.handleSearchAccount()
                }, error: err => {
                    console.log(err)
                }
            })
        } else if (operationType == 'CREDIT') {
            this.accountService.credit(accountId, amount, description).subscribe({
                next: (data) => {
                    alert('Success credit')
                    this.handleSearchAccount()
                }, error: err => {
                    console.log(err)
                }
            })
        } else if (operationType == 'TRANSFER') {
            this.accountService.transfer(accountId, accountDestination, amount, description).subscribe({
                next: (data) => {
                    alert('Success transfer')
                    this.handleSearchAccount()
                }, error: err => {
                    console.log(err)
                }
            })
        }
    }
}
