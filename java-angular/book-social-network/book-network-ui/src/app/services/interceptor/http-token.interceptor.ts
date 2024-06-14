import {HttpEvent, HttpHandler, HttpHeaders, HttpInterceptor, HttpRequest} from '@angular/common/http';
import {Injectable} from "@angular/core";
import {Observable, retry} from "rxjs";
import {TokenService} from "../token/token.service";


@Injectable()
export class HttpTokenInterceptor implements HttpInterceptor {
  constructor(private tokenSrv: TokenService) {
  }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const token = this.tokenSrv.token;
    if (token) {
      const authReq = req.clone({
        headers: new HttpHeaders({
          Authorization: 'Bearer ' + token
        })
      });
      return next.handle(authReq)
    }
    return next.handle(req);
  }

}
