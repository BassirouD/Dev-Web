import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup} from "@angular/forms";
import {ActivatedRoute} from "@angular/router";
import {PaymentType} from "../models/payment.model";
import {PaymentsService} from "../services/payments.service";

@Component({
  selector: 'app-new-payment',
  templateUrl: './new-payment.component.html',
  styleUrl: './new-payment.component.css'
})
export class NewPaymentComponent implements OnInit {
  paymentForm!: FormGroup;
  studentCode!: string
  paymentTypes: string[] = []
  pdfFileUrl!: string
  showProgress: boolean = false;

  constructor(private fb: FormBuilder, private activatedRoute: ActivatedRoute, private paymentSrv: PaymentsService) {
  }

  ngOnInit(): void {
    for (let elt in PaymentType) {
      let value = PaymentType[elt]
      if (typeof value === 'string') {
        this.paymentTypes.push(value);
      }
    }
    this.studentCode = this.activatedRoute.snapshot.params['code']
    this.paymentForm = this.fb.group({
      date: this.fb.control(''),
      amount: this.fb.control(''),
      paymentType: this.fb.control(''),
      studentCode: this.fb.control(this.studentCode),
      fileSource: this.fb.control(''),
      fileName: this.fb.control(''),
    })
  }

  selectFile($event: any) {
    if ($event.target.files.length > 0) {
      let file = $event.target.files[0];
      this.paymentForm.patchValue({
        fileSource: file,
        fileName: file.name
      });
      this.pdfFileUrl = window.URL.createObjectURL(file)
    }
  }

  savePayment() {
    this.showProgress = true
    let date: Date = new Date(this.paymentForm.value.date);
    let formattedDate: string = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear()

    const formData = new FormData();
    console.log(formattedDate)
    formData.append('file', this.paymentForm.get('fileSource')!.value)
    formData.append('amount', this.paymentForm.value.amount)
    formData.append('paymentType', this.paymentForm.value.paymentType)
    formData.append('date', formattedDate)
    formData.append('studentCode', this.paymentForm.value.studentCode)
    this.paymentSrv.savePayment(formData).subscribe({
      next: value => {
        this.showProgress = false
        alert("OKKKKKKKKKK")
      }, error: err => {
        console.log(err)
      }
    })
  }

  afterLoadComplete($event: any) {
    console.log($event)
  }
}
