import 'dart:convert';
import 'dart:io';

import 'package:book_social_network/models/book_request.dart';
import 'package:book_social_network/models/book_response.dart';
import 'package:book_social_network/models/borrowed_book_response.dart';
import 'package:book_social_network/models/feedback_request.dart';
import 'package:book_social_network/models/feedback_response.dart';

import 'http_service.dart';

class BookService {
  final HttpService _httpService;
  BookService(this._httpService);
  // Sauvegarder un livre
  Future<int> saveBook(BookRequest book, File bookCover) async {
    const url = 'books';
    try {
      // Appeler le service pour sauvegarder le livre
      final response = await _httpService.post(url, book.toJson());

      if (response.statusCode == 200) {
        // Récupérer l'ID du livre
        final bookId = jsonDecode(response.body);
        // Uploader la couverture du livre
        await uploadBookCover(bookId, bookCover);
        return bookId;
      } else {
        // Gérer les erreurs
        throw Exception('Failed to save book: ${response.body}');
      }
    } catch (e) {
      // Gérer les exceptions
      throw Exception('Error saving book: $e');
    }
  }

  // Méthode pour uploader la couverture du livre
  Future<void> uploadBookCover(int bookId, File bookCover) async {
    final url = 'books/cover/$bookId';
    try {
      // Appeler le service pour uploader la couverture
      final response = await _httpService.postFile(url, bookCover);

      if (response.statusCode != 202) {
        throw Exception(
            'Failed to upload book cover: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading book cover: $e');
    }
  }

  Future<List<BookResponse>> findAllBooks(int page, int size) async {
    final url = 'books?page=$page&size=$size';
    final response = await _httpService.get(url);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Empty response');
      }
      final jsonData = jsonDecode(response.body);
      if (jsonData == null || jsonData['content'] == null) {
        throw Exception('Invalid JSON format');
      }
      final List<dynamic> booksJson = jsonData['content'];
      return booksJson.map((json) => BookResponse.fromJson(json)).toList();
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load books');
    }
  }

  Future<List<BookResponse>> findAllOwnerBooks(int page, int size) async {
    final url = 'books/owner?page=$page&size=$size';
    final response = await _httpService.get(url);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Empty response');
      }
      final jsonData = jsonDecode(response.body);
      if (jsonData == null || jsonData['content'] == null) {
        throw Exception('Invalid JSON format');
      }
      final List<dynamic> booksJson = jsonData['content'];
      return booksJson.map((json) => BookResponse.fromJson(json)).toList();
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load books');
    }
  }

  Future<List<BorrowedBookResponse>> findAllBorrowedBooks(
      int page, int size) async {
    final url = 'books/borrowed?page=$page&size=$size';
    final response = await _httpService.get(url);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Empty response');
      }
      final jsonData = jsonDecode(response.body);
      if (jsonData == null || jsonData['content'] == null) {
        throw Exception('Invalid JSON format');
      }
      final List<dynamic> booksJson = jsonData['content'];
      return booksJson
          .map((json) => BorrowedBookResponse.fromJson(json))
          .toList();
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load books');
    }
  }

  Future<List<BorrowedBookResponse>> findAllReturnedBooks(
      int page, int size) async {
    final url = 'books/returned?page=$page&size=$size';
    final response = await _httpService.get(url);
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Empty response');
      }
      final jsonData = jsonDecode(response.body);
      if (jsonData == null || jsonData['content'] == null) {
        throw Exception('Invalid JSON format');
      }
      final List<dynamic> booksJson = jsonData['content'];
      return booksJson
          .map((json) => BorrowedBookResponse.fromJson(json))
          .toList();
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load books');
    }
  }

  Future<int> borrowBook(int id) async {
    final url = 'books/borrow/$id';
    try {
      final response = await _httpService.post(url, null);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> returnBorrowBook(int id) async {
    final url = 'books/borrow/return/$id';
    try {
      final response = await _httpService.patch(url, null);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> approveReturnBorrowBook(int id) async {
    final url = 'books/borrow/return/approve/$id';
    try {
      final response = await _httpService.patch(url, null);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> feedback(FeedbackRequest feedback) async {
    const url = 'feedbacks';
    try {
      final response = await _httpService.post(url, feedback);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FeedbackResponse>> fetchFeedbacksByBook(
      int bookId, int page, int size) async {
    final String endpoint = 'feedbacks/book/$bookId?page=$page&size=$size';
    try {
      final response = await _httpService.get(endpoint);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['content'];
        return data.map((json) => FeedbackResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load feedbacks');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BookResponse> getBookById(int bookId) async {
    final String endpoint = 'books/$bookId';

    try {
      final response = await _httpService.get(endpoint);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Assuming the entire body is the book response
        return BookResponse.fromJson(data);
      } else {
        // More descriptive error with status code and message
        throw Exception(
            'Failed to load book. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      // Log the error and rethrow it
      print('Error fetching book by id: $e');
      rethrow;
    }
  }
}
