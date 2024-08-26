import 'dart:convert';
import 'dart:ffi';

import 'package:book_social_network/models/borrowed_book_response.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:book_social_network/widgets/header_widget.dart';
import 'package:book_social_network/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({super.key});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<BorrowedBookResponse> _borrowedBooks = [];

  void _bookAlreadyReturned(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Book already returned',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amberAccent,
      ),
    );
  }

  void _returnBorrowBook(
      BuildContext context, int id, double note, String comment) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    try {
      final borrowId = await bookProvider.returnBorrowBook(id, note, comment);
      Navigator.pop(context);

      // Rechercher le livre retourné dans la liste et mettre à jour son état
      setState(() {
        final bookIndex = _borrowedBooks.indexWhere((book) => book.id == id);
        if (bookIndex != -1) {
          _borrowedBooks[bookIndex] =
              _borrowedBooks[bookIndex].copyWith(returned: true);
        }
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Return borrowed book successfully! ID: $borrowId'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
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

  void _showBookDetails(BuildContext context, BorrowedBookResponse book) {
    double _rating = 0.0; // Déplacer la variable ici pour le modal
    String _feedbackComment = ''; // Variable pour stocker le commentaire

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true, // Permet de contrôler la taille avec le clavier
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              // Utilisation de MediaQuery pour prendre en compte le clavier
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom, // Adapte en fonction du clavier
              ),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.7, // 70% de la hauteur de l'écran
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    // Permet le défilement
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Author: ${book.authorName}'),
                        const SizedBox(height: 8),
                        Text('ISBN: ${book.isbn}'),
                        const SizedBox(height: 8),
                        Text('Rate: ${book.rate}'),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Rate the book:',
                                style: TextStyle(fontSize: 16)),
                            Text('${_rating.toStringAsFixed(1)} / 5.0'),
                          ],
                        ),
                        Slider(
                          value: _rating,
                          onChanged: (newRating) {
                            setState(() {
                              _rating =
                                  newRating; // Met à jour la valeur du slider
                            });
                          },
                          min: 0,
                          max: 5,
                          divisions: 10, // Pour permettre des incréments de 0.5
                          label: _rating.toStringAsFixed(1),
                        ),

                        // Affichage des étoiles selon la note
                        _buildStarRating(_rating),

                        const SizedBox(height: 16),

                        // Champ pour le commentaire
                        TextField(
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Leave a comment',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _feedbackComment =
                                  value; // Met à jour le commentaire
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Bouton pour soumettre le feedback
                        ElevatedButton(
                          onPressed: () => _returnBorrowBook(
                              context, book.id, _rating, _feedbackComment),
                          child: const Text('Rate the book & Return'),
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget to display stars based on rating
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
          .fetchAllBorrowedBooks(_currentPage, 6);

      if (newBooks.isNotEmpty) {
        setState(() {
          _currentPage++;
          _borrowedBooks.addAll(newBooks);
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
      appBar: const HeaderWidget(title: 'Borrowed Books'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _borrowedBooks.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _borrowedBooks.length) {
          // Si on atteint la fin de la liste et qu'il reste des données à charger
          return Center(
              child: _isLoading ? const CircularProgressIndicator() : null);
        }
        final book = _borrowedBooks[index];
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
                  Icons.send_outlined,
                  color: book.returned ? Colors.green : Colors.grey,
                ),
                onPressed: () => book.returned
                    ? _bookAlreadyReturned(context)
                    : _showBookDetails(context, book),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
