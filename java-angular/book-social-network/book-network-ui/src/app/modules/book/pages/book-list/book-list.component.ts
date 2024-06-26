import {Component, OnInit} from '@angular/core';
import {BookService} from "../../../../services/services/book.service";
import {Router} from "@angular/router";
import {PageResponseBookResponse} from "../../../../services/models/page-response-book-response";
import {BookResponse} from "../../../../services/models/book-response";
import {UserService} from "../../../../services/services/user.service";
import {findAllUsers} from "../../../../services/fn/user/find-all-users";
import {TokenService} from "../../../../services/token/token.service";

@Component({
    selector: 'app-book-list',
    templateUrl: './book-list.component.html',
    styleUrl: './book-list.component.scss'
})
export class BookListComponent implements OnInit {
    bookResponse: PageResponseBookResponse = {};
    page: number = 0;
    size: number = 3;
    message: string = '';
    level = 'success'

    constructor(
        private bookSrv: BookService,
        private userSrv: UserService,
        ) {
    }

    ngOnInit(): void {
        this.findAllBooks()
    }



    private findAllBooks() {
        this.bookSrv.findAllBooks({
            page: this.page,
            size: this.size,
        }).subscribe({
            next: (books) => {
                this.bookResponse = books
            }
        })
    }

    goToFirstPage() {
        this.page = 0;
        this.findAllBooks();
    }

    goToPreviousPage() {
        this.page--;
        this.findAllBooks();
    }

    goToPage(page: number) {
        this.page = page
        this.findAllBooks();
    }

    goToNextPage() {
        this.page++;
        this.findAllBooks();
    }

    goToLastPage() {
        this.page = this.bookResponse.totalPages as number - 1;
        this.findAllBooks();
    }

    get isLastPage(): boolean {
        return this.page == this.bookResponse.totalPages as number - 1;
    }

    get totalPages(): any[] {
        // On peut utiliser directement cette methodes pour avoir le totalPages
        // Pour ne pas à faire [].constructor(bookResponse.totalPages) dans le html
        return new Array(this.bookResponse.totalPages);
    }

    borrowBook(book: BookResponse) {
        this.message = ''
        this.bookSrv.borrowBook({
            "book-id": book.id as number
        }).subscribe({
            next: () => {
                this.level = 'success'
                this.message = 'Book successfully add to your list'
            }, error: (err) => {
                this.level = 'error'
                this.message = err.error.error
            }
        })
    }
}
