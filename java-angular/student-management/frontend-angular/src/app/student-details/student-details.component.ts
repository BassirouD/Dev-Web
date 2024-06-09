import {Component, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute, Router} from "@angular/router";
import {StudentsService} from "../services/students.service";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import {Payment} from "../models/payment.model";
import {MatTableDataSource} from "@angular/material/table";

@Component({
  selector: 'app-student-details',
  templateUrl: './student-details.component.html',
  styleUrl: './student-details.component.css'
})
export class StudentDetailsComponent implements OnInit {
  studentCode!: string;
  studentPayments!: Array<Payment>;
  public dataSource!: MatTableDataSource<Payment>
  public displayColumns = ['id', 'date', 'amount', 'paymentType', 'paymentStatus', 'firstName', 'details']
  @ViewChild(MatPaginator) paginator!: MatPaginator
  @ViewChild(MatSort) sort!: MatSort


  constructor(private activatedRoute: ActivatedRoute, private studentSrv: StudentsService, private router: Router) {
  }

  ngOnInit(): void {
    this.studentCode = this.activatedRoute.snapshot.params['code'];
    this.studentSrv.getStudentPayments(this.studentCode).subscribe({
      next: value => {
        this.studentPayments = value
        this.dataSource = new MatTableDataSource<Payment>(this.studentPayments)
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
      }, error: err => {
        console.log(err)
      }
    })
  }

  newPayment() {
    this.router.navigateByUrl(`/admin/new-payment/${this.studentCode}`)
  }

  paymentDetails(element: Payment) {
    this.router.navigateByUrl(`/admin/payment-details/${element.id}`)

  }
}
