import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Student} from "../models/student.model";
import {Payment} from "../models/payment.model";
import {environment} from "../../environments/environment";

@Injectable({
  providedIn: 'root'
})
export class StudentsService {
  host = 'http://localhost:8021'

  constructor(private http: HttpClient) {
  }

  getAllStudents() {
    return this.http.get<Student[]>(`${this.host}/students`);
  }

  getStudentPayments(code:string) {
    return this.http.get<Payment[]>(`${this.host}/students/${code}/payments`);
  }
}
