import {Component, OnInit, ViewChild} from '@angular/core';
import {PaymentsService} from "../services/payments.service";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import {MatTableDataSource} from "@angular/material/table";
import {Payment} from "../models/payment.model";

@Component({
  selector: 'app-load-payments',
  templateUrl: './load-payments.component.html',
  styleUrl: './load-payments.component.css'
})
export class LoadPaymentsComponent implements OnInit {
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
