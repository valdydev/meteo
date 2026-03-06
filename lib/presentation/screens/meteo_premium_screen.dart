import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meteo/logic/blocs/meteo_bloc.dart';
import 'package:meteo/logic/blocs/meteo_event.dart';
import 'package:meteo/logic/blocs/meteo_state.dart';
import 'package:meteo/presentation/screens/details_screen.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:meteo/core/themes_premium.dart';

class MeteoPremiumScreen extends StatelessWidget {
  const MeteoPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fond dynamique profond
          _construireFondProfond(),
          
          SafeArea(
            child: BlocBuilder<MeteoBloc, MeteoState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _construireHeader(context),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: 1.seconds,
                        switchInCurve: Curves.easeOutQuart,
                        child: _construireContenu(context, state),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construireFondProfond() {
    return MeshGradient(
      points: [
        MeshGradientPoint(color: CouleursElite.meshColors[0], position: const Offset(0, 0)),
        MeshGradientPoint(color: CouleursElite.meshColors[1], position: const Offset(1, 0)),
        MeshGradientPoint(color: CouleursElite.meshColors[2], position: const Offset(0, 1)),
        MeshGradientPoint(color: CouleursElite.meshColors[3], position: const Offset(1, 1)),
      ],
      options: MeshGradientOptions(),
    );
  }

  Widget _construireHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          _boutonRond(context, Icons.chevron_left, () => Navigator.pop(context)),
          const Spacer(),
          Text(
            "SYSTÈME ATMOS",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w200,
              letterSpacing: 6,
            ),
          ),
          const Spacer(),
          _boutonRond(context, Icons.grid_view_rounded, () {}),
        ],
      ),
    );
  }

  Widget _boutonRond(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _construireContenu(BuildContext context, MeteoState state) {
    switch (state.statut) {
      case StatutMeteo.chargement:
        return _chargementHautDeGamme(state);
      case StatutMeteo.succes:
        return _listeHautDeGamme(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _chargementHautDeGamme(MeteoState state) {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Cercle de progression minimaliste
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: state.progression,
                  strokeWidth: 1,
                  color: const Color(0xFF00D2FF),
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),
              // Texte central
              Column(
                children: [
                  Text(
                    "${(state.progression * 100).toInt()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  Text(
                    "PERCENT",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ],
          ).animate().scale(duration: 1.seconds, curve: Curves.easeOutBack),
          const SizedBox(height: 80),
          Text(
            state.messageAttente?.toUpperCase() ?? "SYNCHRONISATION...",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              letterSpacing: 3,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .fadeIn(duration: 1.seconds)
           .fadeOut(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _listeHautDeGamme(BuildContext context, MeteoState state) {
    return Stack(
      children: [
        ListView.builder(
          key: const ValueKey('list'),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          itemCount: state.listeMeteo.length,
          itemBuilder: (context, index) {
            final meteo = state.listeMeteo[index];
            return _carteBentoPremium(context, meteo, index);
          },
        ),
        // Bouton Recommencer Flottant Premium
        Positioned(
          bottom: 20,
          left: 30,
          right: 30,
          child: GestureDetector(
            onTap: () => context.read<MeteoBloc>().add(RecommencerMeteo()),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF00D2FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D2FF).withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh_rounded, color: Color(0xFF00D2FF), size: 20),
                        SizedBox(width: 15),
                        Text(
                          "RECOMMENCER L'EXPÉRIENCE",
                          style: TextStyle(
                            color: Color(0xFF00D2FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1.seconds).slideY(begin: 1, end: 0),
        ),
      ],
    );
  }

  Widget _carteBentoPremium(BuildContext context, dynamic meteo, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(meteo: meteo))),
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meteo.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            meteo.weather.first.description.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(child: _infoBento(Icons.water_drop_outlined, "${meteo.main.humidity}%")),
                              const SizedBox(width: 20),
                              Expanded(child: _infoBento(Icons.air, "${meteo.wind.speed} km/h")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${meteo.main.temp.round()}°",
                          style: const TextStyle(
                            color: Color(0xFF00D2FF),
                            fontSize: 44,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        Hero(
                          tag: 'meteo_icon_${meteo.name}',
                          child: Image.network(
                            "https://openweathermap.org/img/wn/${meteo.weather.first.icon}@4x.png",
                            width: 55,
                            height: 55,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: (index * 150).ms, duration: 800.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuint),
    );
  }

  Widget _infoBento(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.3), size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
