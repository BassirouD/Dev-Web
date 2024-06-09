import {Component, OnInit, ViewChild} from '@angular/core';
import {Student} from "../models/student.model";
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import {Router} from "@angular/router";
import {StudentsService} from "../services/students.service";

@Component({
  selector: 'app-students',
  templateUrl: './students.component.html',
  styleUrl: './students.component.css'
})
export class StudentsComponent implements OnInit {
  public students!: Array<Student>;
  public dataSource!: MatTableDataSource<Student>
  public displayColumn = ['id', 'firstName', 'lastName', 'programId', 'payments']
  @ViewChild(MatPaginator) paginator!: MatPaginator
  @ViewChild(MatSort) sort!: MatSort

  constructor(private router: Router, private studentSrv: StudentsService) {

  }

  ngOnInit(): void {
    // for (let i = 1; i < 100; i++) {
    //   this.students.push({
    //     id: i,
    //     firstName: Math.random().toString(20),
    //     lastName: Math.random().toString(20),
    //   })
    // }
    this.studentSrv.getAllStudents().subscribe({
      next: value => {
        this.students = value
        this.dataSource = new MatTableDataSource<Student>(this.students)
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
      }, error: err => {
        console.log(err)
      }
    })
  }


  filterStudents($event: Event) {
    let value = ($event.target as HTMLInputElement).value
    this.dataSource.filter = value;
  }

  getPayments(student: Student) {
    this.router.navigateByUrl(`/admin/student-details/${student.code}`)
  }
}
