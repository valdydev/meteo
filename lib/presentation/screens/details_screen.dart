import 'package:mesh_gradient/mesh_gradient.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meteo/data/models/meteo_model.dart';
import 'package:meteo/core/themes_premium.dart';

class DetailsScreen extends StatefulWidget {
  final MeteoModel meteo;

  const DetailsScreen({super.key, required this.meteo});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late GoogleMapController _mapController;
  
  // Style sombre pour Google Maps
  final String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#212121"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#212121"}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#181818"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#2c2c2c"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#000000"}]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fond Immersif
          _construireFondProfond(),

          // 2. Contenu Scrollable
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header avec Carte Intégrée
              SliverAppBar(
                expandedHeight: 450,
                backgroundColor: Colors.transparent,
                leading: _boutonRetour(context),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // La Carte
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.meteo.coord.lat, widget.meteo.coord.lon),
                              zoom: 12,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _mapController.setMapStyle(_mapStyle);
                            },
                            markers: {
                              Marker(
                                markerId: MarkerId(widget.meteo.name),
                                position: LatLng(widget.meteo.coord.lat, widget.meteo.coord.lon),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                              ),
                            },
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            compassEnabled: false,
                          ),
                        ),
                      ),
                      // Overlay de dégradé pour fusionner la carte avec le contenu
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Titre de la ville
                      Positioned(
                        bottom: 40,
                        left: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.meteo.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ).animate().fadeIn().slideX(begin: -0.2),
                            Text(
                              widget.meteo.weather.first.description.toUpperCase(),
                              style: TextStyle(
                                color: const Color(0xFF00D2FF).withOpacity(0.8),
                                fontSize: 14,
                                letterSpacing: 5,
                                fontWeight: FontWeight.w300,
                              ),
                            ).animate().fadeIn(delay: 200.ms),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Informations Bento
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // Rangée 1 : Température & Humidité
                      Row(
                        children: [
                          Expanded(
                            child: _carteBento(
                              Icons.thermostat_rounded,
                              "TEMPÉRATURE",
                              "${widget.meteo.main.temp.round()}°",
                              const Color(0xFFFF5F6D),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _carteBento(
                              Icons.water_drop_rounded,
                              "HUMIDITÉ",
                              "${widget.meteo.main.humidity}%",
                              const Color(0xFF2193B0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Rangée 2 : Vent & Pression
                      Row(
                        children: [
                          Expanded(
                            child: _carteBento(
                              Icons.air_rounded,
                              "VENT",
                              "${widget.meteo.wind.speed} KM/H",
                              const Color(0xFF11998E),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _carteBento(
                              Icons.compress_rounded,
                              "PRESSION",
                              "${widget.meteo.main.pressure} HPA",
                              const Color(0xFFFDC830),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Rangée 3 : Visibilité & Nuages (Style large)
                      _carteBentoLarge(
                        Icons.visibility_rounded,
                        "VISIBILITÉ",
                        "${(widget.meteo.visibility / 1000).toStringAsFixed(1)} KM",
                        const Color(0xFF00D2FF),
                      ),
                      const SizedBox(height: 20),
                      _carteBentoLarge(
                        Icons.cloud_rounded,
                        "COUVERTURE NUAGEUSE",
                        "${widget.meteo.clouds.all}%",
                        Colors.white70,
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Bouton Recommencer
                      _boutonRecommencer(context),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _construireFondProfond() {
    return AnimatedMeshGradient(
      colors: CouleursElite.meshColors,
      options: AnimatedMeshGradientOptions(
              speed: 0.5,
            ),
    );
  }

  Widget _boutonRetour(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const Icon(Icons.chevron_left, color: Colors.white),
        ),
      ),
    );
  }

  Widget _carteBento(IconData icon, String label, String value, Color color) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w100,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 300.ms, duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _carteBentoLarge(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _boutonRecommencer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Retour à l'écran précédent (MeteoScreen) qui gère le "Recommencer"
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF00D2FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: const Color(0xFF00D2FF).withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            "RETOUR AU SYSTÈME",
            style: TextStyle(
              color: Color(0xFF00D2FF),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }
}
