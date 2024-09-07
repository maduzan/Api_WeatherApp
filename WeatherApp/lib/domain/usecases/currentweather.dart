import 'package:flutter_application_1/domain/entities/currentdata.dart';
import 'package:flutter_application_1/domain/repositories/domainrepo.dart';

class GetWeatherForecast {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  Future<CurrentWeather> execute(double latitude, double longitude) async {
    return await repository.getCurrentWeather(latitude, longitude);
  }
}
