import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {MainComponent} from "./pages/main/main.component";
import {BookListComponent} from "./pages/book-list/book-list.component";
import {MyBookComponent} from "./pages/my-book/my-book.component";
import {ManageBookComponent} from "./pages/manage-book/manage-book.component";
import {BorrowedBookListComponent} from "./pages/borrowed-book-list/borrowed-book-list.component";
import {ReturnBooksComponent} from "./pages/return-books/return-books.component";
import {authGuard} from "../../services/guard/auth.guard";

const routes: Routes = [
    {
        path: '',
        component: MainComponent,
        canActivate: [authGuard],
        children: [
            {path: '', component: BookListComponent, canActivate: [authGuard],},
            {path: 'my-books', component: MyBookComponent, canActivate: [authGuard],},
            {path: 'manage', component: ManageBookComponent, canActivate: [authGuard],},
            {path: 'manage/:bookId', component: ManageBookComponent, canActivate: [authGuard],},
            {path: 'my-borrowed-books', component: BorrowedBookListComponent, canActivate: [authGuard],},
            {path: 'my-return-books', component: ReturnBooksComponent, canActivate: [authGuard],},
        ]
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class BookRoutingModule {
}
