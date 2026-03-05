import 'package:equatable/equatable.dart';

/// Événement de base pour le Bloc Météo
abstract class MeteoEvent extends Equatable {
  const MeteoEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour démarrer le chargement des données météo
class DemarrerChargementMeteo extends MeteoEvent {}

/// Événement pour réinitialiser et recommencer le chargement
class RecommencerMeteo extends MeteoEvent {}
