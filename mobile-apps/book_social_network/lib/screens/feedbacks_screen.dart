import 'package:book_social_network/models/feedback_response.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbacksScreen extends StatefulWidget {
  final int bookId;

  const FeedbacksScreen({super.key, required this.bookId});

  @override
  State<FeedbacksScreen> createState() => _FeedbacksScreenState();
}

class _FeedbacksScreenState extends State<FeedbacksScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les feedbacks dès que la page est ouverte
    Provider.of<BookProvider>(context, listen: false)
        .fetchFeedbacks(widget.bookId, 0, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Feedbacks'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookProvider.feedbacks.isEmpty) {
            return const Center(child: Text('No feedbacks available'));
          }

          return ListView.builder(
            itemCount: bookProvider.feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = bookProvider.feedbacks[index];
              return _buildFeedbackCard(feedback);
            },
          );
        },
      ),
    );
  }

  // Widget pour construire chaque feedback avec un joli design
  Widget _buildFeedbackCard(FeedbackResponse feedback) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage des étoiles (note)
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < feedback.note ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                );
              }),
            ),
            const SizedBox(height: 10),

            // Commentaire
            Text(
              feedback.comment,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Affichage du badge si c'est le feedback de l'utilisateur
            feedback.ownFeedback
                ? const Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Text(
                        'Your feedback',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  )
                : const Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Text(
                        'Not your feedback',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
