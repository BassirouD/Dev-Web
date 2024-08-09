import 'package:book_social_network/screens/constants.dart';
import 'package:book_social_network/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnbordingScreen extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 14,
      ),
      bodyPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Partagez et Empruntez des Livres",
          body: "Notre application vous permet de partager vos livres "
              "avec d'autres membres de la communauté et d'emprunter "
              "des ouvrages que vous souhaitez découvrir. "
              "Chaque livre partagé est une opportunité pour "
              "quelqu'un de plonger dans une nouvelle aventure"
              " littéraire.",
          image: Image.asset(
            "images/icon1.png",
            width: 200,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Évaluez et Validez les Retours",
          body:
              "Une fois le livre lu, notez-le avant de le rendre à son propriétaire."
              " Le propriétaire peut ensuite valider que le livre a bien été retourné. "
              "Ce processus simple et transparent renforce la confiance entre les membres"
              " et enrichit l'expérience de partage.",
          image: Image.asset(
            "images/icon2.png",
            width: 200,
          ),
          decoration: pageDecoration,
          footer: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: kprimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Let's Start",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
      showSkipButton: false,
      showDoneButton: false,
      showBackButton: true,
      showNextButton: true,
      back: const Text(
        "Back",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: kprimaryColor,
        ),
      ),
      next: const Text(
        "Next",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: kprimaryColor,
        ),
      ),
      dotsDecorator: const DotsDecorator(
        // size: Size.square(10),
        activeColor: kprimaryColor,
        /*
        spacing: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        activeSize: Size(20,10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),*/
      ),
    );
  }
}
