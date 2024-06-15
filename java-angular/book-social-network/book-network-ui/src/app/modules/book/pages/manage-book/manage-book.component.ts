import {Component} from '@angular/core';
import {BookRequest} from "../../../../services/models/book-request";
import {BookService} from "../../../../services/services/book.service";
import {Router} from "@angular/router";

@Component({
    selector: 'app-manage-book',
    templateUrl: './manage-book.component.html',
    styleUrl: './manage-book.component.scss'
})
export class ManageBookComponent {
    errorMsg: Array<string> = new Array<string>()
    selectedBookCover: any;
    selectedPicture: string | undefined;
    bookRequest: BookRequest = {
        authorName: "Rakhmane",
        isbn: "12223-7748883-8568866",
        synopsis: "A very detailed book talking about pyhton",
        title: "Python for pro"};

    constructor(private bookSrv: BookService, private router: Router) {
    }

    onFileSelected($event: any) {
        this.selectedBookCover = $event.target.files[0];
        console.log(this.selectedBookCover)
        if (this.selectedBookCover) {
            const reader = new FileReader();
            reader.onload = () => {
                this.selectedPicture = reader.result as string;
            }
            reader.readAsDataURL(this.selectedBookCover)
        }
    }

    saveBook() {
        this.bookSrv.saveBook({
            body: this.bookRequest
        }).subscribe({
            next: (bookId) => {
                this.bookSrv.uploadBookCoverPicture({
                    "book-id": bookId,
                    body: {
                        file: this.selectedBookCover
                    }
                }).subscribe({
                    next: () => {
                        this.router.navigate(['/books/my-books'])
                    }
                })
            }, error: (err) => {
                this.errorMsg = err.error.validationErrors;
            }
        })
    }
}
