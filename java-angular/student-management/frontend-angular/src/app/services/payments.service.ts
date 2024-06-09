import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Payment} from "../models/payment.model";

@Injectable({
  providedIn: 'root'
})
export class PaymentsService {
  host = 'http://localhost:8021'

  constructor(private http: HttpClient) {
  }

  getAllPayments() {
    return this.http.get<Payment[]>(`${this.host}/payments`);
  }

  savePayment(formDate: any) {
    return this.http.post<Payment>(`${this.host}/payments`, formDate);
  }

  getPaymentDetails(paymentId: number) {
    return this.http.get(`${this.host}/paymentFile/${paymentId}`,
      {
        responseType: 'blob'
      });
  }
}
