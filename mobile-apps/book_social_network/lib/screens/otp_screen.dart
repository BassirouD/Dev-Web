import 'package:book_social_network/providers/auth_provider.dart';
import 'package:book_social_network/screens/constants.dart';
import 'package:book_social_network/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.lightBlueAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  TextEditingController textEditingController = TextEditingController(text: "");

  void validate(BuildContext context) async {
    final String token = textEditingController.text.trim();

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Token is required',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: CupertinoColors.systemYellow,
        ),
      );
      return;
    }
    try {
      await Provider.of<AuthProvider>(context, listen: false).activate(token);
      // Rediriger après succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your account has been successfully activated. \nNow you can process to login',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The token has been expired or invalid: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please enter the OTP that we have sent you to your email.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldPin(
                textController: textEditingController,
                autoFocus: true,
                codeLength: 6,
                alignment: MainAxisAlignment.center,
                defaultBoxSize: 40,
                margin: 5,
                selectedBoxSize: 42.0,
                textStyle: const TextStyle(fontSize: 16),
                defaultDecoration: _pinPutDecoration.copyWith(
                    border: Border.all(color: Colors.grey)),
                selectedDecoration: _pinPutDecoration,
                onChange: (code) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => validate(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  backgroundColor: kprimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
