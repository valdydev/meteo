

import 'package:flutter_test/flutter_test.dart';
import 'package:meteo/main.dart';
import 'package:meteo/data/api/meteo_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/logic/blocs/meteo_bloc.dart';

void main() {
  testWidgets('Test de fumée de l\'application météo', (WidgetTester tester) async {
    // Initialisation minimale pour le test
    final dio = Dio();
    final meteoApi = MeteoApi(dio);
    
    // Construction de l'application et déclenchement d'un frame.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MeteoBloc>(
            create: (context) => MeteoBloc(meteoApi: meteoApi),
          ),
        ],
        child: MonAppMeteo(meteoApi: meteoApi),
      ),
    );

    // Vérifier que l'écran d'accueil est affiché
    expect(find.textContaining('Bienvenue'), findsOneWidget);
  });
}
