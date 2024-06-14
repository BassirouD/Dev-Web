import {Component} from '@angular/core';
import {AuthenticationRequest} from "../../services/models/authentication-request";
import {Router} from "@angular/router";
import {AuthenticationService} from "../../services/services/authentication.service";
import {TokenService} from "../../services/token/token.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {
  authRequest: AuthenticationRequest = {email: 'tata@book-social.com', password: 'password11'}
  errMsg: Array<string> = [];

  constructor(private router: Router,
              private authSrv: AuthenticationService,
              private tokenSrv: TokenService
  ) {
  }

  login() {
    this.errMsg = [];
    this.authSrv.authenticate({
      body: this.authRequest
    }).subscribe({
      next: (res) => {
        this.tokenSrv.token = res.token as string
        this.router.navigate(['books'])
      },
      error: (err) => {
        console.log(err)
        if (err.error.validationErrors) {
          this.errMsg = err.error.validationErrors
        } else {
          this.errMsg.push(err.error.error)
        }
      }
    })
  }

  register() {
    this.router.navigate(['register'])
  }
}
