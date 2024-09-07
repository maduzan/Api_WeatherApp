import 'package:flutter_application_1/domain/entities/currentdata.dart';
import 'package:flutter_application_1/domain/entities/twentyfoure.dart';

abstract class WeatherRepository {
  Future<CurrentWeather> getCurrentWeather(double latitude, double longitude);
  Future<List<Weather>> getHourlyForecast(double latitude, double longitude);
}
