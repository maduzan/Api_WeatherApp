import 'package:flutter_application_1/domain/entities/twentyfoure.dart';
import 'package:flutter_application_1/domain/repositories/domainrepo.dart';

class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<List<Weather>> execute(double latitude, double longitude) async {
    return await repository.getHourlyForecast(latitude, longitude);
  }
}
