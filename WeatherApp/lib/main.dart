import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/datasource/apicall.dart';
import 'package:flutter_application_1/data/repositories/datarepo.dart';
import 'package:flutter_application_1/domain/usecases/currentweather.dart';
import 'package:flutter_application_1/domain/usecases/twentyfoureusecases.dart';
import 'package:flutter_application_1/presentation/pages/home.dart';
import 'package:flutter_application_1/presentation/providers/pproviders.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final weatherRemoteDataSource =
                WeatherRemoteDataSourceImpl(http.Client());
            final weatherRepository =
                Datarepo(remoteDataSource: weatherRemoteDataSource);

            final getWeatherForecast = GetWeatherForecast(weatherRepository);
            final getCurrentWeather = GetForecast(weatherRepository);

            return WeatherProvider(getWeatherForecast, getCurrentWeather);
          },
        ),
      ],
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}
