import 'package:book_social_network/providers/auth_provider.dart';
import 'package:book_social_network/providers/book_provider.dart';
import 'package:book_social_network/screens/bottom_bar_screen.dart';
import 'package:book_social_network/screens/login_screen.dart';
import 'package:book_social_network/screens/splash_screen.dart';
import 'package:book_social_network/services/book_service.dart';
import 'package:book_social_network/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisez le HttpService
  final httpService = HttpService(null);
  final bookService = BookService(httpService);

  // Créez l'AuthProvider en chargeant le token
  final authProvider = AuthProvider(httpService);
  final bookProvider = BookProvider(bookService);

  await authProvider.loadToken();

  runApp(MyApp(
    authProvider: authProvider,
    bookProvider: bookProvider,
  ));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final BookProvider bookProvider;

  const MyApp(
      {super.key, required this.authProvider, required this.bookProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<BookProvider>.value(value: bookProvider),
      ],
      child: MaterialApp(
        title: 'Book Social Network',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          indicatorColor: Colors.deepPurple,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primarySwatch: Colors.blue,
        ),
        home: authProvider.isTokenNotValid()
            ? const LoginScreen()
            : const BottomBarScreen(),
      ),
    );
  }

// This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   // return MaterialApp(
  //   //   title: 'Book Social Network',
  //   //   debugShowCheckedModeBanner: false,
  //   //   theme: ThemeData(
  //   //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //   //     useMaterial3: true,
  //   //   ),
  //   //   home: const LoginScreen(),
  //   // );
  //
  //   return ChangeNotifierProvider(
  //     create: (context) => AuthProvider(),
  //     child: MaterialApp(
  //       title: 'Book Social Network',
  //       debugShowCheckedModeBanner: false,
  //       theme: ThemeData(
  //         indicatorColor: Colors.deepPurple,
  //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: const BottomBarScreen(),
  //     ),
  //   );
  // }
}
