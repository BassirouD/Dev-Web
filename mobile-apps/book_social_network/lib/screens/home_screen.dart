import 'dart:convert';

import 'package:book_social_network/models/book_response.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:book_social_network/screens/feedbacks_screen.dart';
import 'package:book_social_network/widgets/header_widget.dart';
import 'package:book_social_network/widgets/my_drawer.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> carImages = [
    "images/car1.jpg",
    "images/car2.jpg",
    "images/car3.jpg",
  ];

  void _borrowBook(BuildContext context, int id) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    try {
      final borrowId = await bookProvider.borrowBook(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book borrowed successfully! ID: $borrowId'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: const HeaderWidget(title: 'Home'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                          ),
                          label: Text("Find you book"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 6,
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.notifications),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: FanCarouselImageSlider.sliderType1(
                    imagesLink: carImages,
                    sliderHeight: 180,
                    autoPlay: true,
                    isAssets: true,
                    showArrowNav: false,
                    showIndicator: false,
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Newest books",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("View all"),
                    ),
                  ],
                ),
                //Ici le code pour l'affichage des livres ?
                FutureBuilder<List<BookResponse>>(
                  future: Provider.of<BookProvider>(context, listen: false)
                      .fetchBooks(0, 5),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No books found.'));
                    } else {
                      final books = snapshot.data!;
                      return SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: books.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return SizedBox(
                              width: 300,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: book.cover.isNotEmpty
                                                ? Image.memory(
                                                    base64Decode(book.cover),
                                                    fit: BoxFit.cover,
                                                    width: 160,
                                                    height: 200,
                                                  )
                                                : const Icon(Icons.book,
                                                    size: 50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(CupertinoIcons.book),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              book.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(CupertinoIcons.person),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              book.authorName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                                CupertinoIcons.person_alt),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              book.owner,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        /* Row(
                                          children: [
                                            const Icon(CupertinoIcons
                                                .keyboard_chevron_compact_down),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              book.isbn,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                          ],
                                        ),*/
                                        // const SizedBox(height: 15),
                                        _buildStarRating(book.rate),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              iconSize: 20,
                                              onPressed: () =>
                                                  _borrowBook(context, book.id),
                                              icon: const Icon(
                                                  Icons.import_export_sharp),
                                            ),
                                            IconButton(
                                              iconSize: 20,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FeedbacksScreen(
                                                            bookId: book.id),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.checklist_outlined),
                                            ),
                                            IconButton(
                                              iconSize: 20,
                                              onPressed: () {},
                                              icon: const Icon(
                                                  CupertinoIcons.heart),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
