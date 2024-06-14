import {Component} from '@angular/core';
import {RegistrationRequest} from "../../services/models/registration-request";
import {Router} from "@angular/router";
import {AuthenticationService} from "../../services/services/authentication.service";

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrl: './register.component.scss'
})
export class RegisterComponent {
  registerRequest: RegistrationRequest = {email: '@email.com', firstname: '', lastname: '', password: 'password11'}
  errMsg: Array<string> = [];

  constructor(private router: Router, private authSrv: AuthenticationService) {
  }

  register() {
    this.errMsg = [];
    this.authSrv.register({
      body: this.registerRequest
    }).subscribe({
      next: () => {
        this.router.navigate(['activate-account'])
      }, error: (err) => {
        console.log(err)
        if (err.error.validationErrors) {
          this.errMsg = err.error.validationErrors
        } else {
          this.errMsg.push(err.error.error)
        }
      }
    })
  }

  login() {
    this.router.navigate(['login'])
  }
}
