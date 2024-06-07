import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup} from "@angular/forms";
import {AuthenticationService} from "../services/authentication.service";
import {Router} from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent implements OnInit {
  public loginFormGroup!: FormGroup

  constructor(private fb: FormBuilder, private authSrv: AuthenticationService, private router: Router) {
  }

  ngOnInit(): void {
    this.loginFormGroup = this.fb.group({
      username: this.fb.control('admin'),
      password: this.fb.control('1234'),
    })
  }

  login() {
    let username = this.loginFormGroup.value.username;
    let password = this.loginFormGroup.value.password;
    let auth = this.authSrv.login(username, password)
    if (auth)
      return this.router.navigateByUrl('/admin')
    else
      return this.router.navigateByUrl('/login')
  }
}
