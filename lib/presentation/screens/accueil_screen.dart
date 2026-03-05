import 'package:flutter/material.dart';
import 'package:meteo/presentation/screens/meteo_screen.dart';

/// Écran d'accueil de l'application météo
class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controleur;
  late Animation<double> _animationOpacite;
  late Animation<Offset> _animationGlissement;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur d'animation pour l'entrée
    _controleur = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animation de fondu
    _animationOpacite = CurvedAnimation(
      parent: _controleur,
      curve: Curves.easeIn,
    );

    // Animation de glissement vers le haut
    _animationGlissement = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controleur,
      curve: Curves.easeOutBack,
    ));

    // Démarrage de l'animation
    _controleur.forward();
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _animationOpacite,
            child: SlideTransition(
              position: _animationGlissement,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône météo animée avec une légère rotation continue
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 4),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value * 2.0 * 3.14159,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 140,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Météo Royale",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Votre compagnon météo ultime",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Préparez-vous à une expérience météo immersive et en temps réel.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  _construireBoutonMagique(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le bouton magique pour lancer l'expérience
  Widget _construireBoutonMagique(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigation avec une transition personnalisée
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MeteoScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 15,
        shadowColor: Colors.black45,
      ),
      child: const Text(
        "Lancer l'expérience ✨",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
