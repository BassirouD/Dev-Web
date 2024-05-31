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
    currentPage: number = 0;
    pageSize: number = 5
    accountObservable$!: Observable<AccountDetails>;

    constructor(private fb: FormBuilder, private accountService: AccountsService) {
    }

    ngOnInit(): void {
        this.accountFormGroup = this.fb.group({
            accountId: ['']
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
}
