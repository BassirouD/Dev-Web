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
        return this.http.get<AccountDetails>(this.apiUrl + '/account/' + accountId + '/pageOperations?page=' + page + '&size=' + size)
    }

}
