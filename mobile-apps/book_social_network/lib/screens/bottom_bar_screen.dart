import 'package:book_social_network/screens/borrow_screen.dart';
import 'package:book_social_network/screens/home_screen.dart';
import 'package:book_social_network/screens/my_book_screen.dart';
import 'package:book_social_network/screens/return_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentTab = 0;
  List screens = [
    HomeScreen(),
    const Scaffold(),
    const MyBookScreen(),
    const ReturnScreen(),
    const BorrowScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() {
                currentTab = 0;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 0 ? Icons.home : CupertinoIcons.home,
                    color: currentTab == 0
                        ? Theme.of(context).indicatorColor
                        : Colors.grey,
                  ),
                  const Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                currentTab = 1;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 1
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: currentTab == 1
                        ? Theme.of(context).indicatorColor
                        : Colors.grey,
                  ),
                  const Text(
                    "Favorites",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                currentTab = 2;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 2
                        ? CupertinoIcons.book_solid
                        : CupertinoIcons.book,
                    color: currentTab == 2
                        ? Theme.of(context).indicatorColor
                        : Colors.grey,
                  ),
                  const Text(
                    "Books",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                currentTab = 3;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 3
                        ? Icons.assignment_return_rounded
                        : Icons.assignment_late_outlined,
                    color: currentTab == 3
                        ? Theme.of(context).indicatorColor
                        : Colors.grey,
                  ),
                  const Text(
                    "Return",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                currentTab = 4;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 4
                        ? Icons.account_balance
                        : Icons.account_balance_outlined,
                    color: currentTab == 4
                        ? Theme.of(context).indicatorColor
                        : Colors.grey,
                  ),
                  const Text(
                    "Borrowed",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: screens[currentTab],
    );
  }
}
