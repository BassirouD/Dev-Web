import 'package:book_social_network/providers/auth_provider.dart';
import 'package:book_social_network/screens/constants.dart';
import 'package:book_social_network/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false;

  final _emailController = TextEditingController(text: 'saliou@email.com');
  final _passwordController = TextEditingController(text: 'password11');

  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true; // Démarrer le chargement
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.login(
        _emailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Login successful!',
            style: TextStyle(color: Colors.white), // Couleur du texte
          ),
          backgroundColor: Colors.green, // Couleur d'arrière-plan
          behavior: SnackBarBehavior.floating, // Fait flotter le SnackBar
          margin:
              const EdgeInsets.only(bottom: 100.0), // Marge au bas de l'écran
          shape: RoundedRectangleBorder(
            // Forme du SnackBar
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6.0, // Élévation pour l'effet d'ombre
          duration: const Duration(seconds: 3), // Durée d'affichage du SnackBar
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.only(bottom: 100.0),
          shape: RoundedRectangleBorder(
            // Forme du SnackBar
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6.0,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Arrêter le chargement
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset("images/log.jpg"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Enter Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            _obscureText
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 16,
                            color: kprimaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading // Afficher l'indicateur de chargement ou le bouton
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _login(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: kprimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              color: kprimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
