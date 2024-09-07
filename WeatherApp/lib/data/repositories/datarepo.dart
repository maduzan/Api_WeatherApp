import 'package:flutter_application_1/data/datasource/apicall.dart';
import 'package:flutter_application_1/domain/entities/twentyfoure.dart';
import 'package:flutter_application_1/domain/repositories/domainrepo.dart';

import '../../domain/entities/currentdata.dart';

class Datarepo implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  Datarepo({
    required this.remoteDataSource,
  });

  @override
  Future<CurrentWeather> getCurrentWeather(
      double latitude, double longitude) async {
    final model = await remoteDataSource.getCurrentWeather(latitude, longitude);
    return CurrentWeather(
        location: model.location,
        icon: model.icon,
        temperature: model.temperature,
        weatherDescription: model.weatherDescription);
  }

  @override
  Future<List<Weather>> getHourlyForecast(
      double latitude, double longitude) async {
    final responce =
        await remoteDataSource.getHourlyForecast(latitude, longitude);
    return responce.hourlyForecast
        .map((data) => Weather(
              dateTime: data.dateTime,
              temperature: data.temperature,
              weatherDescription: data.weatherDescription,
            ))
        .toList();
  }
}
