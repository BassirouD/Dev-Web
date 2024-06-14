import {Component} from '@angular/core';
import {AuthenticationRequest} from "../../services/models/authentication-request";
import {Router} from "@angular/router";
import {AuthenticationService} from "../../services/services/authentication.service";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {
  authRequest: AuthenticationRequest = {email: '', password: ''}
  errMsg: Array<string> = [];

  constructor(private router: Router,
              private authSrv: AuthenticationService) {
  }

  login() {
    this.errMsg = [];
    this.authSrv.authenticate({
      body: this.authRequest
    }).subscribe({
      next: (res) => {
        //todo save token
        this.router.navigate(['books'])
      },
      error: (err) => {
        console.log(err)
      }
    })
  }

  register() {
    this.router.navigate(['register'])
  }
}
