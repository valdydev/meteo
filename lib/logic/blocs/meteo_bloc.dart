import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meteo/data/api/meteo_api.dart';
import 'package:meteo/data/models/meteo_model.dart';
import 'package:meteo/logic/blocs/meteo_event.dart';
import 'package:meteo/logic/blocs/meteo_state.dart';

class MeteoBloc extends Bloc<MeteoEvent, MeteoState> {
  final MeteoApi meteoApi;
  // REMPLACER PAR VOTRE CLÉ API OPENWEATHER
  final String _cleApi = "7d46292c8c97d46e37da92b9d456b35f";
  final List<String> villes = ["Paris", "Londres", "Tokyo", "New York", "Dakar"];

  MeteoBloc({required this.meteoApi}) : super(const MeteoState()) {
    // Gestionnaire pour le démarrage du chargement
    on<DemarrerChargementMeteo>(_surDemarrerChargement);
    // Gestionnaire pour recommencer l'expérience
    on<RecommencerMeteo>(_surRecommencer);
  }

  /// Vérifie et demande les permissions de localisation
  Future<Position?> _obtenirPositionActuelle() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  /// Fonction principale pour gérer le processus de chargement de la météo
  Future<void> _surDemarrerChargement(
    DemarrerChargementMeteo event,
    Emitter<MeteoState> emit,
  ) async {
    // On initialise l'état à "chargement"
    emit(state.copyWith(
      statut: StatutMeteo.chargement,
      progression: 0.0,
      listeMeteo: [],
      erreur: null,
      messageAttente: "Recherche de votre position actuelle...",
    ));

    List<MeteoModel> resultats = [];

    // 1. Récupérer la localisation actuelle en premier
    try {
      final position = await _obtenirPositionActuelle();
      if (position != null) {
        final meteoLocale = await meteoApi.obtenirMeteoParCoordonnees(
          lat: position.latitude,
          lon: position.longitude,
          apiKey: _cleApi,
        );
        // On renomme la ville locale pour plus de clarté
        final meteoLocaleRenommee = MeteoModel(
          name: "Ma Position (${meteoLocale.name})",
          main: meteoLocale.main,
          weather: meteoLocale.weather,
          wind: meteoLocale.wind,
          coord: meteoLocale.coord,
          visibility: meteoLocale.visibility,
          clouds: meteoLocale.clouds,
        );
        resultats.add(meteoLocaleRenommee);
      }
    } catch (e) {
      print("Erreur localisation: $e");
      // On continue quand même avec les autres villes si la localisation échoue
    }

    int indexVille = 0;
    int totalPas = 60;

    // Simulation d'un chargement progressif sur 6 secondes
    for (int i = 1; i <= totalPas; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      double progression = i / totalPas.toDouble();

      // Messages dynamiques selon l'avancement
      String message = "Nous téléchargeons les données...";
      if (progression > 0.4) message = "C’est presque fini...";
      if (progression > 0.8) message = "Plus que quelques secondes avant d’avoir le résultat...";

      // Récupération des 5 villes prédéfinies
      if (i % 12 == 0 && indexVille < villes.length) {
        try {
          final meteo = await meteoApi.obtenirMeteo(
            ville: villes[indexVille],
            apiKey: _cleApi,
          );
          resultats.add(meteo);
          indexVille++;
        } catch (e) {
          emit(state.copyWith(
            statut: StatutMeteo.erreur,
            erreur:
                "Erreur lors de la récupération des données pour ${villes[indexVille]}. Vérifiez votre connexion ou la clé API.",
          ));
          return;
        }
      }

      // Mise à jour de la jauge et du message
      emit(state.copyWith(
        progression: progression,
        messageAttente: message,
      ));
    }

    // Une fois terminé, on affiche le tableau des résultats
    emit(state.copyWith(
      statut: StatutMeteo.succes,
      listeMeteo: resultats,
      progression: 1.0,
    ));
  }

  /// Réinitialise et relance le chargement
  void _surRecommencer(RecommencerMeteo event, Emitter<MeteoState> emit) {
    add(DemarrerChargementMeteo());
  }
}
