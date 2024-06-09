import {Component, OnInit} from '@angular/core';
import {PaymentsService} from "../services/payments.service";
import {ActivatedRoute} from "@angular/router";

@Component({
  selector: 'app-payment-details',
  templateUrl: './payment-details.component.html',
  styleUrl: './payment-details.component.css'
})
export class PaymentDetailsComponent implements OnInit {
  paymentId!: number
  pdfUrl: any

  constructor(private paymentSrv: PaymentsService, private route: ActivatedRoute) {
  }

  ngOnInit(): void {
    this.paymentId = this.route.snapshot.params['id'];
    this.paymentSrv.getPaymentDetails(this.paymentId).subscribe({
      next: value => {
        let blob = new Blob([value], {type: 'application/pdf'});
        this.pdfUrl = window.URL.createObjectURL(blob)
      }, error: err => {
        console.log(err)
      }
    })
  }

  afterLoadComplete($event: any) {

  }
}
