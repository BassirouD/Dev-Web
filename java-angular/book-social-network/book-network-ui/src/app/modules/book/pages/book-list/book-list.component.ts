import {Component, OnInit} from '@angular/core';
import {BookService} from "../../../../services/services/book.service";
import {Router} from "@angular/router";
import {PageResponseBookResponse} from "../../../../services/models/page-response-book-response";

@Component({
    selector: 'app-book-list',
    templateUrl: './book-list.component.html',
    styleUrl: './book-list.component.scss'
})
export class BookListComponent implements OnInit {
    bookResponse: PageResponseBookResponse = {};
    page: number = 0;
    size: number = 2;


    ngOnInit(): void {
        this.findAllBooks()
    }


    constructor(private bookSrv: BookService, private router: Router) {
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
}
