import 'package:book_social_network/widgets/my_drawer_header.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          MyDrawerHeader(),
        ],
      ),
    );
  }
}
