import {Injectable} from '@angular/core';
import {JwtHelperService} from "@auth0/angular-jwt";

@Injectable({
    providedIn: 'root'
})
export class TokenService {

    constructor() {
    }

    set token(token: string) {
        localStorage.setItem('token', token);
    }

    get token() {
        return localStorage.getItem('token') as string;
    }

    isTokenNotValid() {
        return !this.isTokenValid();
    }

    private isTokenValid() {
        const token = this.token;
        if (!token) {
            return false
        }
        //decode token
        const jwtHelper = new JwtHelperService();
        //check expire date
        const isTokenExpired = jwtHelper.isTokenExpired(token)
        if (isTokenExpired) {
            localStorage.clear();
            return false;
        }
        return true;
    }
}
