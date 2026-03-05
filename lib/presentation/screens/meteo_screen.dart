import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/data/models/meteo_model.dart';
import 'package:meteo/logic/blocs/meteo_bloc.dart';
import 'package:meteo/logic/blocs/meteo_event.dart';
import 'package:meteo/logic/blocs/meteo_state.dart';
import 'package:meteo/presentation/screens/details_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Écran principal affichant la jauge de progression et les résultats météo
class MeteoScreen extends StatefulWidget {
  const MeteoScreen({super.key});

  @override
  State<MeteoScreen> createState() => _MeteoScreenState();
}

class _MeteoScreenState extends State<MeteoScreen> {
  @override
  void initState() {
    super.initState();
    // Démarrage automatique du chargement à l'entrée sur l'écran
    context.read<MeteoBloc>().add(DemarrerChargementMeteo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Météo en Direct",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<MeteoBloc, MeteoState>(
        builder: (context, etat) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _construireContenu(etat),
          );
        },
      ),
    );
  }

  /// Sélectionne le widget à afficher selon l'état du Bloc
  Widget _construireContenu(MeteoState etat) {
    if (etat.statut == StatutMeteo.erreur) {
      return _construireErreur(etat.erreur ?? "Une erreur est survenue");
    }

    if (etat.statut == StatutMeteo.succes) {
      return _construireTableau(etat.listeMeteo);
    }

    return _construireChargement(etat);
  }

  /// Construit l'interface de chargement avec la jauge de progression circulaire
  Widget _construireChargement(MeteoState etat) {
    return Center(
      key: const ValueKey('chargement'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 130.0,
              lineWidth: 15.0,
              animation: true,
              animateFromLastPercent: true,
              percent: etat.progression,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(etat.progression * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 42.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Text(
                    "Chargement",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              footer: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    etat.messageAttente,
                    key: ValueKey(etat.messageAttente),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le tableau interactif des résultats météo avec animations
  Widget _construireTableau(List<MeteoModel> listeMeteo) {
    return Column(
      key: const ValueKey('tableau'),
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: listeMeteo.length,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            itemBuilder: (context, index) {
              final meteo = listeMeteo[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 500 + (index * 150)),
                curve: Curves.easeOutQuart,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(50 * (1 - value), 0),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 5,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: Hero(
                      tag: 'meteo_icon_${meteo.name}',
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          "https://openweathermap.org/img/wn/${meteo.weather.first.icon}@2x.png",
                          width: 55,
                        ),
                      ),
                    ),
                    title: Text(
                      meteo.name, 
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        meteo.weather.first.description.substring(0, 1).toUpperCase() + 
                        meteo.weather.first.description.substring(1),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${meteo.main.temp.toInt()}°C",
                          style: const TextStyle(
                            fontSize: 26, 
                            fontWeight: FontWeight.w900,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(meteo: meteo),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        _construireBoutonRecommencer(),
      ],
    );
  }

  /// Bouton stylé pour relancer l'expérience
  Widget _construireBoutonRecommencer() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: ElevatedButton.icon(
          onPressed: () {
            context.read<MeteoBloc>().add(RecommencerMeteo());
          },
          icon: const Icon(Icons.refresh_rounded, size: 28),
          label: const Text(
            "RECOMMENCER L'EXPÉRIENCE",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.1),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 65),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 8,
          ),
        ),
      ),
    );
  }

  /// Construit l'interface d'erreur avec un design épuré
  Widget _construireErreur(String message) {
    return Center(
      key: const ValueKey('erreur'),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 100, color: Colors.redAccent),
            ),
            const SizedBox(height: 30),
            const Text(
              "Oups !",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MeteoBloc>().add(DemarrerChargementMeteo());
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text("Réessayer maintenant"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
