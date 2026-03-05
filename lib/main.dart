import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:meteo/core/themes_premium.dart';
import 'package:meteo/data/api/meteo_api.dart';
import 'package:meteo/logic/blocs/meteo_bloc.dart';
import 'package:meteo/presentation/screens/accueil_premium_screen.dart';
import 'package:meteo/presentation/screens/meteo_premium_screen.dart';
import 'package:meteo/presentation/screens/details_screen.dart';

void main() {
  final dio = Dio();
  final meteoApi = MeteoApi(dio);

  runApp(MonAppMeteo(meteoApi: meteoApi));
}

class MonAppMeteo extends StatelessWidget {
  final MeteoApi meteoApi;

  const MonAppMeteo({super.key, required this.meteoApi});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MeteoBloc(meteoApi: meteoApi),
        ),
      ],
      child: MaterialApp(
        title: 'ATMOS ELITE',
        debugShowCheckedModeBanner: false,
        theme: ThemesElite.themeElite3D,
        initialRoute: '/',
        routes: {
          '/': (context) => const AccueilPremiumScreen(),
          '/meteo': (context) => const MeteoPremiumScreen(),
        },
      ),
    );
  }
}
