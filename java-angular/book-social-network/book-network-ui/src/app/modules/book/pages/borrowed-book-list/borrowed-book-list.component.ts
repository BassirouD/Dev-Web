import {Component, OnInit} from '@angular/core';
import {PageResponseBorrowedBookResponse} from "../../../../services/models/page-response-borrowed-book-response";
import {BorrowedBookResponse} from "../../../../services/models/borrowed-book-response";
import {BookService} from "../../../../services/services/book.service";
import {FeedbackRequest} from "../../../../services/models/feedback-request";
import {FeedbackService} from "../../../../services/services/feedback.service";

@Component({
    selector: 'app-borrowed-book-list',
    templateUrl: './borrowed-book-list.component.html',
    styleUrl: './borrowed-book-list.component.scss'
})
export class BorrowedBookListComponent implements OnInit {
    feedbackRequest: FeedbackRequest = {bookId: 0, comment: "", note: 0}
    borrowBooks: PageResponseBorrowedBookResponse = {};
    page = 0;
    size = 5
    public selectedBook: BorrowedBookResponse | undefined = undefined;

    constructor(private bookService: BookService,
                private feedbackSrv: FeedbackService) {
    }

    ngOnInit(): void {
        this.findAllBorrowedBooks()
    }

    returnBorrowedBook(book: BorrowedBookResponse) {
        this.selectedBook = book;
        this.feedbackRequest.bookId = book.id as number
    }

    private findAllBorrowedBooks() {
        this.bookService.findAllBorrowedBooks({
            page: this.page,
            size: this.size
        }).subscribe({
            next: (resp) => {
                this.borrowBooks = resp;
            }
        });
    }

    returnBook(withFeedback: boolean) {
        this.bookService.returnBorrowBook({
            "book-id": this.selectedBook?.id as number
        }).subscribe({
            next: () => {
                if (withFeedback) {
                    this.giveFeedback();
                }
                this.selectedBook = undefined;
                this.findAllBorrowedBooks()
            }
        })
    }

    private giveFeedback() {
        this.feedbackSrv.saveFeedBack({
            body: this.feedbackRequest
        }).subscribe({
            next: () => {

            }
        })
    }

    goToFirstPage() {
        this.page = 0;
        this.findAllBorrowedBooks();
    }

    goToPreviousPage() {
        this.page--;
        this.findAllBorrowedBooks();
    }

    goToPage(page: number) {
        this.page = page
        this.findAllBorrowedBooks();
    }

    goToNextPage() {
        this.page++;
        this.findAllBorrowedBooks();
    }

    goToLastPage() {
        this.page = this.borrowBooks.totalPages as number - 1;
        this.findAllBorrowedBooks();
    }

    get isLastPage(): boolean {
        return this.page == this.borrowBooks.totalPages as number - 1;
    }

    get totalPages(): any[] {
        // On peut utiliser directement cette methodes pour avoir le totalPages
        // Pour ne pas à faire [].constructor(bookResponse.totalPages) dans le html
        return new Array(this.borrowBooks.totalPages);
    }

}
