import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BookRoutingModule } from './book-routing.module';
import { MainComponent } from './pages/main/main.component';
import { MenuComponent } from './components/menu/menu.component';
import { BookListComponent } from './pages/book-list/book-list.component';
import { BookCardComponent } from './components/book-card/book-card.component';
import { RatingComponent } from './components/rating/rating.component';
import { MyBookComponent } from './pages/my-book/my-book.component';


@NgModule({
  declarations: [
    MainComponent,
    MenuComponent,
    BookListComponent,
    BookCardComponent,
    RatingComponent,
    MyBookComponent
  ],
  imports: [
    CommonModule,
    BookRoutingModule
  ]
})
export class BookModule { }
