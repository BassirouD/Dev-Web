import 'dart:io';

import 'package:book_social_network/models/book_request.dart';
import 'package:book_social_network/models/book_response.dart';
import 'package:book_social_network/models/borrowed_book_response.dart';
import 'package:book_social_network/models/feedback_request.dart';
import 'package:book_social_network/models/feedback_response.dart';
import 'package:book_social_network/services/book_service.dart';
import 'package:flutter/cupertino.dart';

class BookProvider with ChangeNotifier {
  final BookService _bookService;
  BookResponse? _book;
  BookResponse? get book => _book;
  List<FeedbackResponse> _feedbacks = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<FeedbackResponse> get feedbacks => _feedbacks;

  BookProvider(this._bookService);

  Future<void> saveBookWithCover(
      BookRequest bookRequest, File bookCover) async {
    try {
      // Sauvegarde du livre et récupération de l'ID
      await _bookService.saveBook(bookRequest, bookCover);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future<List<BookResponse>> fetchBooks(int page, int size) async {
    return await _bookService.findAllBooks(page, size);
  }

  Future<List<BookResponse>> fetchOwnerBooks(int page, int size) async {
    return await _bookService.findAllOwnerBooks(page, size);
  }

  Future<List<BorrowedBookResponse>> fetchAllBorrowedBooks(
      int page, int size) async {
    return await _bookService.findAllBorrowedBooks(page, size);
  }

  Future<List<BorrowedBookResponse>> fetchAllReturnedBooks(
      int page, int size) async {
    return await _bookService.findAllReturnedBooks(page, size);
  }

  Future<int> borrowBook(int id) async {
    return await _bookService.borrowBook(id);
  }

  Future<int> returnBorrowBook(int id, double note, String comment) async {
    await _bookService.returnBorrowBook(id);
    return await feedback(note, comment, id);
  }

  Future<int> approveReturnBorrowBook(int id) async {
    return await _bookService.approveReturnBorrowBook(id);
  }

  Future<int> feedback(double note, String comment, int bookId) async {
    final request =
        FeedbackRequest(note: note, comment: comment, bookId: bookId);
    return await _bookService.feedback(request);
  }

  Future<void> fetchFeedbacks(int bookId, int page, int size) async {
    _isLoading = true;
    notifyListeners();
    try {
      _feedbacks = await _bookService.fetchFeedbacksByBook(bookId, page, size);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetBookById(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _book = await _bookService.getBookById(id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
