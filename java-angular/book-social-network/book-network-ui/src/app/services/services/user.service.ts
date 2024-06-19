/* tslint:disable */
/* eslint-disable */
import { HttpClient, HttpContext } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { BaseService } from '../base-service';
import { ApiConfiguration } from '../api-configuration';
import { StrictHttpResponse } from '../strict-http-response';

import { findAllUsers } from '../fn/user/find-all-users';
import { FindAllUsers$Params } from '../fn/user/find-all-users';
import { PageResponseUserResponse } from '../models/page-response-user-response';

@Injectable({ providedIn: 'root' })
export class UserService extends BaseService {
  constructor(config: ApiConfiguration, http: HttpClient) {
    super(config, http);
  }

  /** Path part for operation `findAllUsers()` */
  static readonly FindAllUsersPath = '/manage';

  /**
   * This method provides access to the full `HttpResponse`, allowing access to response headers.
   * To access only the response body, use `findAllUsers()` instead.
   *
   * This method doesn't expect any request body.
   */
  findAllUsers$Response(params?: FindAllUsers$Params, context?: HttpContext): Observable<StrictHttpResponse<PageResponseUserResponse>> {
    return findAllUsers(this.http, this.rootUrl, params, context);
  }

  /**
   * This method provides access only to the response body.
   * To access the full response (for headers, for example), `findAllUsers$Response()` instead.
   *
   * This method doesn't expect any request body.
   */
  findAllUsers(params?: FindAllUsers$Params, context?: HttpContext): Observable<PageResponseUserResponse> {
    return this.findAllUsers$Response(params, context).pipe(
      map((r: StrictHttpResponse<PageResponseUserResponse>): PageResponseUserResponse => r.body)
    );
  }

}
