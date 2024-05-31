import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {AccountDetails} from "../models/account.model";

@Injectable({
    providedIn: 'root'
})
export class AccountsService {

    private apiUrl = 'http://localhost:8085';

    constructor(private http: HttpClient) {
    }

    getAccount(accountId: string, page: number, size: number) {
        return this.http.get<AccountDetails>(this.apiUrl + '/accounts/' + accountId + '/pageOperations?page=' + page + '&size=' + size)
    }

    debit(accountId: string, amount: number, description: string) {
        let data = {
            'accountId': accountId, 'amount': amount, 'description': description
        }
        return this.http.post(this.apiUrl + '/accounts/debit', data)
    }

    credit(accountId: string, amount: number, description: string) {
        let data = {
            'accountId': accountId, 'amount': amount, 'description': description
        }
        return this.http.post(this.apiUrl + '/accounts/credit', data)
    }

    transfer(accountSource: string, accountDestinantion: string, amount: number, description: string) {
        let data = {
            accountSource, accountDestinantion, amount, description
        }
        return this.http.post(this.apiUrl + '/accounts/transfer', data)
    }


}
