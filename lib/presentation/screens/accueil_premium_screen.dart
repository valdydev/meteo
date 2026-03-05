import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/logic/blocs/meteo_bloc.dart';
import 'package:meteo/logic/blocs/meteo_event.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class AccueilPremiumScreen extends StatefulWidget {
  const AccueilPremiumScreen({super.key});

  @override
  State<AccueilPremiumScreen> createState() => _AccueilPremiumScreenState();
}

class _AccueilPremiumScreenState extends State<AccueilPremiumScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationX = 0;
  double _rotationY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fond Dynamique Shaders (Simulation par Mesh Gradients animés)
          _construireFondDynamique(),
          
          // 2. Contenu Immersif
          SafeArea(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rotationY += details.delta.dx * 0.01;
                  _rotationX -= details.delta.dy * 0.01;
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // 3. Objet 3D Central (Simulé par perspective matricielle)
                    _construireObjet3D(),
                    const Spacer(),
                    
                    // 4. Texte Vision Pro
                    _construireTextePremium(),
                    
                    const SizedBox(height: 80),
                    
                    // 5. Bouton "Bento" Premium
                    _construireBoutonBento(context),
                    
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construireFondDynamique() {
    return Stack(
      children: [
        // Dégradé profond
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [Color(0xFF0A1128), Colors.black],
            ),
          ),
        ),
        // Particules de lumière (Simulation)
        ...List.generate(5, (index) {
          return Positioned(
            top: index * 200.0,
            left: index * 100.0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF00D2FF).withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .move(duration: (8 + index).seconds, begin: const Offset(-50, -50), end: const Offset(50, 50)),
          );
        }),
        // Flou Gaussien Dynamique sur toute la scène
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _construireObjet3D() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(_rotationX)
        ..rotateY(_rotationY),
      alignment: FractionalOffset.center,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D2FF).withOpacity(0.3),
              blurRadius: 100,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(140),
          child: Stack(
            children: [
              // Image météo ultra-réaliste
              Image.network(
                "https://images.unsplash.com/photo-1534088568595-a066f410bcda?q=80&w=1000&auto=format&fit=crop",
                fit: BoxFit.cover,
                width: 280,
                height: 280,
              ),
              // Effet de reflet de verre
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.4),
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .moveY(duration: 4.seconds, begin: -10, end: 10, curve: Curves.easeInOut),
    );
  }

  Widget _construireTextePremium() {
    return Column(
      children: [
        Text(
          "ATMOS",
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w100,
            letterSpacing: 25,
            color: Colors.white.withOpacity(0.9),
            fontFamily: 'SF Pro Display',
          ),
        ).animate().fadeIn(duration: 1.seconds).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 10),
        Container(
          height: 1,
          width: 100,
          color: const Color(0xFF00D2FF).withOpacity(0.5),
        ).animate().scaleX(duration: 1.5.seconds, begin: 0, end: 1, curve: Curves.easeOutExpo),
        const SizedBox(height: 20),
        Text(
          "L'ÉVOLUTION CLIMATIQUE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 8,
            color: Colors.white.withOpacity(0.5),
          ),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _construireBoutonBento(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MeteoBloc>().add(DemarrerChargementMeteo());
        Navigator.of(context).pushNamed('/meteo');
      },
      child: Container(
        width: 320,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "EXPLORER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.arrow_forward_ios, color: Color(0xFF00D2FF), size: 16),
                    ],
                  ),
                ),
                // Effet de balayage lumineux
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.3, 0.5, 0.7],
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat())
                   .moveX(duration: 2.seconds, begin: -300, end: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1.seconds).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}
