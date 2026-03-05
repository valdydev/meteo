class MeteoModel {
  final String name;
  final MainModel main;
  final List<WeatherModel> weather;
  final WindModel wind;
  final CoordModel coord;
  final int visibility;
  final CloudsModel clouds;

  MeteoModel({
    required this.name,
    required this.main,
    required this.weather,
    required this.wind,
    required this.coord,
    required this.visibility,
    required this.clouds,
  });

  factory MeteoModel.fromJson(Map<String, dynamic> json) {
    return MeteoModel(
      name: json['name'] as String,
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      coord: CoordModel.fromJson(json['coord'] as Map<String, dynamic>),
      visibility: json['visibility'] as int? ?? 0,
      clouds: CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>? ?? {'all': 0}),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'main': main.toJson(),
        'weather': weather.map((e) => e.toJson()).toList(),
        'wind': wind.toJson(),
        'coord': coord.toJson(),
        'visibility': visibility,
        'clouds': clouds.toJson(),
      };
}

class CloudsModel {
  final int all;

  CloudsModel({required this.all});

  factory CloudsModel.fromJson(Map<String, dynamic> json) {
    return CloudsModel(all: json['all'] as int? ?? 0);
  }

  Map<String, dynamic> toJson() => {'all': all};
}

class MainModel {
  final double temp;
  final double humidity;
  final double pressure;

  MainModel({
    required this.temp,
    required this.humidity,
    required this.pressure,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      temp: (json['temp'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'temp': temp,
        'humidity': humidity,
        'pressure': pressure,
      };
}

class WeatherModel {
  final String main;
  final String description;
  final String icon;

  WeatherModel({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'main': main,
        'description': description,
        'icon': icon,
      };
}

class WindModel {
  final double speed;

  WindModel({required this.speed});

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: (json['speed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'speed': speed,
      };
}

class CoordModel {
  final double lat;
  final double lon;

  CoordModel({required this.lat, required this.lon});

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };
}
