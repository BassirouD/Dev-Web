import 'dart:convert';

import 'package:book_social_network/models/borrowed_book_response.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:book_social_network/widgets/header_widget.dart';
import 'package:book_social_network/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<BorrowedBookResponse> _returnedBooks = [];

  void _bookAlreadyApproved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Book already approved',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amberAccent,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMoreBooks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreData) {
        _loadMoreBooks();
      }
    });
  }

  Future<void> _loadMoreBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newBooks = await Provider.of<BookProvider>(context, listen: false)
          .fetchAllReturnedBooks(_currentPage, 6);

      if (newBooks.isNotEmpty) {
        setState(() {
          _currentPage++;
          _returnedBooks.addAll(newBooks);
        });
      } else {
        setState(() {
          _hasMoreData = false; // Plus de données à charger
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Terminer le chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: const HeaderWidget(title: 'Returned Books'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _returnedBooks.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _returnedBooks.length) {
          // Si on atteint la fin de la liste et qu'il reste des données à charger
          return Center(
              child: _isLoading ? const CircularProgressIndicator() : null);
        }
        final book = _returnedBooks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text('${index + 1}'),
              ),
              title: Text(book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Author: ${book.authorName}'),
                  Text('ISBN: ${book.isbn}'),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      Text(' ${book.rate}'),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: book.returnApproved ? Colors.green : Colors.grey,
                ),
                onPressed: () => book.returnApproved
                    ? _bookAlreadyApproved(context)
                    : _approveReturnedBorrowBook(context, book.id),
              ),
            ),
          ),
        );
      },
    );
  }

  void _approveReturnedBorrowBook(BuildContext context, int id) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    try {
      final borrowId = await bookProvider.approveReturnBorrowBook(id);
      setState(() {
        final bookIndex = _returnedBooks.indexWhere((book) => book.id == id);
        if (bookIndex != -1) {
          _returnedBooks[bookIndex] =
              _returnedBooks[bookIndex].copyWith(returnApproved: true);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Approved Returned borrowed book successfully! ID: $borrowId'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      String errorMessage = 'An error occurred';

      final jsonStartIndex = e.toString().indexOf('{');
      if (jsonStartIndex != -1) {
        final jsonString = e.toString().substring(jsonStartIndex);
        final errorJson = jsonDecode(jsonString);

        if (errorJson is Map<String, dynamic> &&
            errorJson.containsKey('error')) {
          errorMessage = errorJson['error'];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
