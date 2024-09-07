import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/currentdata.dart';
import 'package:flutter_application_1/domain/entities/twentyfoure.dart';
import 'package:flutter_application_1/domain/usecases/currentweather.dart';
import 'package:flutter_application_1/domain/usecases/twentyfoureusecases.dart';

class WeatherProvider with ChangeNotifier {
  final GetWeatherForecast getWeatherForecast;
  final GetForecast getCurrentWeather;

  WeatherProvider(this.getWeatherForecast, this.getCurrentWeather);

  List<Weather> _hourlyForecast = [];

  CurrentWeather? _currentWeather;

  List<Weather> get hourlyForecast => _hourlyForecast;

  CurrentWeather? get currentWeather => _currentWeather;

  Future<void> fetchWeather(double latitude, double longitude) async {
    try {
      _hourlyForecast = (await getCurrentWeather.execute(latitude, longitude));

      _currentWeather = (await getWeatherForecast.execute(latitude, longitude))
          as CurrentWeather?;

      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
