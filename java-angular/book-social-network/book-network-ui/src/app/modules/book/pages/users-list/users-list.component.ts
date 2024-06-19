import {Component, OnInit} from '@angular/core';
import {UserService} from "../../../../services/services/user.service";
import {PageResponseUserResponse} from "../../../../services/models/page-response-user-response";

@Component({
    selector: 'app-users-list',
    templateUrl: './users-list.component.html',
    styleUrl: './users-list.component.scss'
})
export class UsersListComponent implements OnInit {
    userResponse: PageResponseUserResponse = {}
    page = 0;
    size = 5
    message = '';
    level = 'success';

    ngOnInit(): void {
        this.findAllUsers()
    }

    constructor(private userSrv: UserService) {
    }

    findAllUsers() {
        this.userSrv.findAllUsers({
            page: this.page,
            size: this.size
        }).subscribe({
            next: (value) => {
                this.userResponse = value
                console.log(value)
            }, error: err => {
                console.log(err)
            }
        })
    }

    goToFirstPage() {
        this.page = 0;
        this.findAllUsers();
    }

    goToPreviousPage() {
        this.page--;
        this.findAllUsers();
    }

    goToPage(page: number) {
        this.page = page
        this.findAllUsers();
    }

    goToNextPage() {
        this.page++;
        this.findAllUsers();
    }

    goToLastPage() {
        this.page = this.userResponse.totalPages as number - 1;
        this.findAllUsers();
    }

    get isLastPage(): boolean {
        return this.page == this.userResponse.totalPages as number - 1;
    }

    get totalPages(): any[] {
        // On peut utiliser directement cette methodes pour avoir le totalPages
        // Pour ne pas à faire [].constructor(bookResponse.totalPages) dans le html
        return new Array(this.userResponse.totalPages);
    }


}
