import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, ReactiveFormsModule, Validators} from "@angular/forms";
import {CustomersService} from "../services/customers.service";
import {NgIf} from "@angular/common";
import {Router} from "@angular/router";

@Component({
    selector: 'app-new-customer',
    standalone: true,
    imports: [
        ReactiveFormsModule,
        NgIf
    ],
    templateUrl: './new-customer.component.html',
    styleUrl: './new-customer.component.css'
})
export class NewCustomerComponent implements OnInit {
    newCustomerFormGroup!: FormGroup

    constructor(private fb: FormBuilder,
                private customerService: CustomersService,
                private router: Router
    ) {
    }

    ngOnInit(): void {
        this.newCustomerFormGroup = this.fb.group({
            name: this.fb.control(null, [Validators.required, Validators.minLength(4)]),
            email: this.fb.control(null, [Validators.required, Validators.email])
        })
    }

    handleSaveCustomer() {
        let customer = this.newCustomerFormGroup.value
        this.customerService.saveCustomer(customer).subscribe({
            next: (data) => {
                console.log(data)
                this.newCustomerFormGroup.reset()
                this.router.navigateByUrl('/customers')
            }, error: err => {
                console.log(err)
            }
        })
    }
}
