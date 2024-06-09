import {Component, OnInit, ViewChild} from '@angular/core';
import {Payment} from "../models/payment.model";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import {PaymentsService} from "../services/payments.service";
import {MatTableDataSource} from "@angular/material/table";

@Component({
  selector: 'app-payments',
  templateUrl: './payments.component.html',
  styleUrl: './payments.component.css'
})
export class PaymentsComponent implements OnInit{
  public payments!: Payment[];
  public dataSource: any
  public displayColumns = ['id', 'date', 'amount', 'paymentType', 'paymentStatus', 'firstName']
  @ViewChild(MatPaginator) paginator!: MatPaginator
  @ViewChild(MatSort) sort!: MatSort


  constructor(private paymentSrv: PaymentsService) {
  }

  ngOnInit(): void {
    this.paymentSrv.getAllPayments().subscribe({
      next: data => {
        this.payments = data;
        this.dataSource = new MatTableDataSource(this.payments)
        this.dataSource.paginator = this.paginator
        this.dataSource.sort = this.sort;
      }, error: err => {
        console.log(err)
      }
    })
  }

  filterPayments($event: Event) {
    this.dataSource.filter = ($event.target as HTMLInputElement).value;
  }
}
