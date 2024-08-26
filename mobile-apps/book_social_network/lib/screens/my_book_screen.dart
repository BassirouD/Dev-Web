import 'dart:convert';

import 'package:book_social_network/models/book_response.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:book_social_network/screens/add_book.dart';
import 'package:book_social_network/screens/feedbacks_screen.dart';
import 'package:book_social_network/widgets/header_widget.dart';
import 'package:book_social_network/widgets/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBookScreen extends StatefulWidget {
  const MyBookScreen({super.key});

  @override
  State<MyBookScreen> createState() => _MyBookScreenState();
}

class _MyBookScreenState extends State<MyBookScreen> {
  List<String> carImages = [
    "images/car1.jpg",
    "images/car2.jpg",
    "images/car3.jpg",
  ];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<BookResponse> _ownerBooks = [];

  Future<void> _loadMoreBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newBooks = await Provider.of<BookProvider>(context, listen: false)
          .fetchOwnerBooks(_currentPage, 4);

      if (newBooks.isNotEmpty) {
        setState(() {
          _currentPage++;
          _ownerBooks.addAll(newBooks);
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

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Colors.yellow),
        if (hasHalfStar) const Icon(Icons.star_half, color: Colors.yellow),
        for (int i = 0; i < emptyStars; i++)
          const Icon(Icons.star_border, color: Colors.yellow),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: const HeaderWidget(title: 'My Books'),
      body: Center(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _ownerBooks.length + (_hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _ownerBooks.length) {
              return Center(
                  child: _isLoading ? const CircularProgressIndicator() : null);
            }
            final book = _ownerBooks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: 150,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: book.cover.isNotEmpty
                                ? Image.memory(
                                    base64Decode(book.cover),
                                    fit: BoxFit.cover,
                                    width: 160,
                                    height: 200,
                                  )
                                : const Icon(Icons.book, size: 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(CupertinoIcons.book),
                          const SizedBox(width: 5),
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.person),
                          const SizedBox(width: 5),
                          Text(
                            book.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.person_alt),
                          const SizedBox(width: 5),
                          Text(
                            book.owner,
                            style: const TextStyle(
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildStarRating(book.rate),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            iconSize: 20,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddBook(bookId: book.id),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            iconSize: 20,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeedbacksScreen(bookId: book.id),
                                ),
                              );
                            },
                            icon: const Icon(Icons.checklist_outlined),
                          ),
                          IconButton(
                            iconSize: 20,
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.heart),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // Ajout du Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBook(),
            ),
          );
        }, // Icône du bouton
        backgroundColor: Theme.of(context).primaryColor, // Couleur du bouton
        tooltip: 'Add a new book',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // Tooltip quand on survole le bouton
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Localisation en bas à droite
    );
  }
}
