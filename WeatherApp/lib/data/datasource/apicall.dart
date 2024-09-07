import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/data/modul/apimodul.dart';
import 'package:flutter_application_1/data/modul/apimodulcurrent.dart';

abstract class WeatherRemoteDataSource {
  Future<CurrentWeatherModel> getCurrentWeather(
      double latitude, double longitude);
  Future<WeatherResponse> getHourlyForecast(double latitude, double longitude);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://api.weatherapi.com/v1';
  final String apiKey = 'cc45359498a54193a2853202240409';
  WeatherRemoteDataSourceImpl(this.client);

  @override
  Future<CurrentWeatherModel> getCurrentWeather(
      double latitude, double longitude) async {
    final response = await client.get(
        Uri.parse('$baseUrl/current.json?key=$apiKey&q=$latitude,$longitude'));
    if (response.statusCode == 200) {
      return CurrentWeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  @override
  Future<WeatherResponse> getHourlyForecast(
      double latitude, double longitude) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/forecast.json?key=$apiKey&q=$latitude,$longitude,$longitude'));
    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load hourly forecast');
    }
  }
}
