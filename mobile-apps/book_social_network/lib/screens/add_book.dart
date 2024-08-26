import 'dart:io';

import 'package:book_social_network/models/book_request.dart';
import 'package:book_social_network/models/book_response.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  final int? bookId; // Optional bookId to indicate editing mode
  const AddBook({super.key, this.bookId});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  File? _selectedBookCover; // Stocker l'image sélectionnée
  final ImagePicker _picker = ImagePicker();

  String? selectedPicture; // L'URL de l'image sélectionnée
  bool isShareable = false; // CheckBox "Share me
  bool _isLoading = false; // Loading state for fetching book data

  @override
  void initState() {
    super.initState();

    // If we're editing, fetch the book data by its ID
    if (widget.bookId != null) {
      _fetchBookData(widget.bookId!);
    }
  }

  // Fetch book data based on the bookId
  Future<void> _fetchBookData(int bookId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the book data using the provider
      await Provider.of<BookProvider>(context, listen: false)
          .fetBookById(bookId);
      final BookResponse? book =
          Provider.of<BookProvider>(context, listen: false).book;

      if (book != null) {
        // Populate the text controllers with the book data
        _titleController.text = book.title;
        _authorController.text = book.authorName;
        _isbnController.text = book.isbn;
        _synopsisController.text = book.synopsis;
        isShareable = book.shareable;

        if (book.cover != null) {
          selectedPicture =
              book.cover; // Assuming book.cover is a URL or local path
        }
      }
    } catch (e) {
      print("Failed to load book: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fonction pour sélectionner une image depuis la galerie ou la caméra
  Future<void> _selectPicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedBookCover = File(pickedFile.path);
        selectedPicture = pickedFile.path;
      });
    }
  }

  // Fonction pour sauvegarder le livre via le provider
  Future<void> _saveBook(BuildContext context) async {
    final String title = _titleController.text.trim();
    final String authorName = _authorController.text.trim();
    final String isbn = _isbnController.text.trim();
    final String synopsis = _synopsisController.text.trim();

    // Validation de base
    if (title.isEmpty ||
        authorName.isEmpty ||
        isbn.isEmpty ||
        synopsis.isEmpty ||
        _selectedBookCover == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields and add a cover image',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: CupertinoColors.systemYellow,
        ),
      );
      return;
    }

    try {
      // Création de l'objet BookRequest
      final bookRequest = BookRequest(
        title: title,
        authorName: authorName,
        isbn: isbn,
        synopsis: synopsis,
        shareable: isShareable,
      );

      // Utilisation du provider pour sauvegarder le livre et uploader l'image
      await Provider.of<BookProvider>(context, listen: false)
          .saveBookWithCover(bookRequest, _selectedBookCover!);

      // Rediriger après succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Book saved successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save/update book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId == null ? 'Add a New Book' : 'Edit Book'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image du livre (centrée pour mobile)
              Center(
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: _selectedBookCover != null
                      ? Image.file(_selectedBookCover!, fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              // Bouton pour ajouter une image
              Center(
                child: ElevatedButton.icon(
                  onPressed: _selectPicture,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add Image'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Champs du formulaire
              _buildTextField(_titleController, 'Title', 'Enter book title'),
              const SizedBox(height: 15),

              // Row pour Author Name et ISBN sur la même ligne
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        _authorController, 'Author Name', 'Enter author name'),
                  ),
                  const SizedBox(width: 10), // Espacement entre les deux champs
                  Expanded(
                    child: _buildTextField(
                        _isbnController, 'ISBN', 'Enter book ISBN'),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              _buildTextField(
                  _synopsisController, 'Synopsis', 'Enter book synopsis',
                  maxLines: 2),
              const SizedBox(height: 15),

              // Case à cocher pour "Share me"
              Row(
                children: [
                  Checkbox(
                    value: isShareable,
                    onChanged: (bool? value) {
                      setState(() {
                        isShareable = value!;
                      });
                    },
                  ),
                  const Text('Share me'),
                ],
              ),
              const SizedBox(height: 20),

              // Boutons Save et Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _saveBook(context),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour construire les champs du formulaire
  Widget _buildTextField(
      TextEditingController controller, String label, String placeholder,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
