import {Component} from '@angular/core';
import {Router} from "@angular/router";
import {AuthenticationService} from "../../services/services/authentication.service";

@Component({
  selector: 'app-activate-account',
  templateUrl: './activate-account.component.html',
  styleUrl: './activate-account.component.scss'
})
export class ActivateAccountComponent {
  message = ''
  isOk = true
  submitted = false

  constructor(private router: Router, private authSrv: AuthenticationService) {
  }

  onCodeCompleted(token: string) {
    this.confirmAccount(token);
  }

  redirectToLogin() {
    this.router.navigate(['login'])
  }

  private confirmAccount(token: string) {
    this.authSrv.confirm({
      token
    }).subscribe({
      next: () => {
        this.message = 'Your account has been successfully activated. \nNow you can process to login'
        this.submitted = true
        this.isOk=true
      }, error: () => {
        this.message = 'The token has been expired or invalid'
        this.submitted = true
        this.isOk = false
      }
    })
  }
}
