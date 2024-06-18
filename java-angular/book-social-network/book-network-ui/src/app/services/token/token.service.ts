import {Injectable} from '@angular/core';
import {JwtHelperService} from "@auth0/angular-jwt";

interface JwtPayload {
    fullName: string;
    sub: string;
    iat: number;
    exp: number;
    authorities: string[];
}

@Injectable({
    providedIn: 'root'
})
export class TokenService {
    public username!: string;


    constructor() {
    }

    parseJWT(jwt: string) {
        let jwtHelper = new JwtHelperService();
        let objJWT = jwtHelper.decodeToken(jwt);
        this.username = objJWT?.fullName;
    }

    get fullName(){
        return localStorage.getItem('username')
    }


    set token(token: string) {
        localStorage.setItem('token', token);
        this.parseJWT(token);
        localStorage.setItem('username', this.username)
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
