import {Component, OnInit} from '@angular/core';
import {PageResponseBookResponse} from "../../../../services/models/page-response-book-response";
import {BookService} from "../../../../services/services/book.service";
import {Router} from "@angular/router";
import {BookResponse} from "../../../../services/models/book-response";

@Component({
    selector: 'app-my-book',
    templateUrl: './my-book.component.html',
    styleUrl: './my-book.component.scss'
})
export class MyBookComponent implements OnInit {
    bookResponse: PageResponseBookResponse = {};
    page: number = 0;
    size: number = 3;


    ngOnInit(): void {
        this.findAllBooks()
    }


    constructor(private bookSrv: BookService, private router: Router) {
    }

    private findAllBooks() {
        this.bookSrv.findAllBooksByOwner({
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


    archiveBook(book: BookResponse) {
        this.bookSrv.updateArchivedStatus({
            "book-id": book.id as number
        }).subscribe({
            next: () => {
                book.archived = !book.archived
            }
        })
    }

    shareBook(book: BookResponse) {
        this.bookSrv.updateShareableStatus({
            "book-id": book.id as number
        }).subscribe({
            next: () => {
                book.shareable = !book.shareable
            }
        })
    }

    editBook(book: BookResponse) {
        this.router.navigate(['books', 'manage', book.id])
    }
}
