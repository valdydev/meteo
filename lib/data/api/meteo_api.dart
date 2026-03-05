import 'package:dio/dio.dart';
import 'package:meteo/data/models/meteo_model.dart';

class MeteoApi {
  final Dio _dio;
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/";

  MeteoApi(this._dio);

  /// Récupère la météo pour une ville donnée par son nom
  Future<MeteoModel> obtenirMeteo({
    required String ville,
    required String apiKey,
  }) async {
    try {
      final response = await _dio.get(
        "${_baseUrl}weather",
        queryParameters: {
          "q": ville,
          "appid": apiKey,
          "units": "metric",
          "lang": "fr",
        },
      );
      return MeteoModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Récupère la météo par coordonnées géographiques (Latitude, Longitude)
  Future<MeteoModel> obtenirMeteoParCoordonnees({
    required double lat,
    required double lon,
    required String apiKey,
  }) async {
    try {
      final response = await _dio.get(
        "${_baseUrl}weather",
        queryParameters: {
          "lat": lat,
          "lon": lon,
          "appid": apiKey,
          "units": "metric",
          "lang": "fr",
        },
      );
      return MeteoModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
