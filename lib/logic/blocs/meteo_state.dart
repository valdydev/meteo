import 'package:equatable/equatable.dart';
import 'package:meteo/data/models/meteo_model.dart';

enum StatutMeteo { initial, chargement, succes, erreur }

class MeteoState extends Equatable {
  final StatutMeteo statut;
  final List<MeteoModel> listeMeteo;
  final double progression;
  final String messageAttente;
  final String? erreur;

  const MeteoState({
    this.statut = StatutMeteo.initial,
    this.listeMeteo = const [],
    this.progression = 0.0,
    this.messageAttente = "Nous téléchargeons les données...",
    this.erreur,
  });

  MeteoState copyWith({
    StatutMeteo? statut,
    List<MeteoModel>? listeMeteo,
    double? progression,
    String? messageAttente,
    String? erreur,
  }) {
    return MeteoState(
      statut: statut ?? this.statut,
      listeMeteo: listeMeteo ?? this.listeMeteo,
      progression: progression ?? this.progression,
      messageAttente: messageAttente ?? this.messageAttente,
      erreur: erreur ?? this.erreur,
    );
  }

  @override
  List<Object?> get props => [statut, listeMeteo, progression, messageAttente, erreur];
}
