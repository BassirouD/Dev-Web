import {
  ActivatedRouteSnapshot,
  GuardResult,
  MaybeAsync, Router,
  RouterStateSnapshot
} from '@angular/router';
import {Injectable} from "@angular/core";
import {AuthenticationService} from "../services/authentication.service";
import {elementAt} from "rxjs";

@Injectable()
export class AuthorizationGuard {
  constructor(private authSrv: AuthenticationService, private router: Router) {
  }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): MaybeAsync<GuardResult> {
    let authorize = false;
    let authorizedRole: string[] = route.data['roles'];
    let roles: string[] = this.authSrv.roles as string[];
    for (let role of this.authSrv.roles) {
      if (authorizedRole.includes(role))
        authorize = true;
    }
    return authorize;
  }

}

