import {Component, OnInit} from '@angular/core';
import {PageResponseBorrowedBookResponse} from "../../../../services/models/page-response-borrowed-book-response";
import {BorrowedBookResponse} from "../../../../services/models/borrowed-book-response";
import {BookService} from "../../../../services/services/book.service";
import {FeedbackService} from "../../../../services/services/feedback.service";

@Component({
    selector: 'app-return-books',
    templateUrl: './return-books.component.html',
    styleUrl: './return-books.component.scss'
})
export class ReturnBooksComponent implements OnInit {
    returnBooks: PageResponseBorrowedBookResponse = {};
    page = 0;
    size = 5
    message = '';
    level = 'success';

    constructor(private bookService: BookService) {
    }

    ngOnInit(): void {
        this.findAllReturnBooks()
    }

    private findAllReturnBooks() {
        this.bookService.findAllReturnedBooks({
            page: this.page,
            size: this.size
        }).subscribe({
            next: (resp) => {
                this.returnBooks = resp;
            }
        });
    }

    goToFirstPage() {
        this.page = 0;
        this.findAllReturnBooks();
    }

    goToPreviousPage() {
        this.page--;
        this.findAllReturnBooks();
    }

    goToPage(page: number) {
        this.page = page
        this.findAllReturnBooks();
    }

    goToNextPage() {
        this.page++;
        this.findAllReturnBooks();
    }

    goToLastPage() {
        this.page = this.returnBooks.totalPages as number - 1;
        this.findAllReturnBooks();
    }

    get isLastPage(): boolean {
        return this.page == this.returnBooks.totalPages as number - 1;
    }

    get totalPages(): any[] {
        // On peut utiliser directement cette methodes pour avoir le totalPages
        // Pour ne pas à faire [].constructor(bookResponse.totalPages) dans le html
        return new Array(this.returnBooks.totalPages);
    }

    approveReturn(book: BorrowedBookResponse) {
        if (!book.returned) {
            this.level='error'
            this.message='Book is not yet returned'
            return;
        }
        this.bookService.approveReturnBorrowBook({
            "book-id": book.id as number
        }).subscribe({
            next: () => {
                this.level = 'success'
                this.message = 'Book return approved'
                this.findAllReturnBooks()
            }
        })
    }
}
