import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/providers/pproviders.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    // Fetch the weather data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      weatherProvider.fetchWeather(6.04, 80.22);
      _fetchWeatherWithCurrentLocation(weatherProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/weather.jpg'),
          fit: BoxFit.cover,
          opacity: 130,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Center(
                child: Text(
              'Live Weather  Forcast',
              style: TextStyle(color: const Color.fromARGB(255, 244, 59, 59)),
            ))),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              ' ${weatherProvider.currentWeather?.location ?? "N/A"}',
              style: const TextStyle(fontSize: 35, color: Colors.white),
            ),
            const SizedBox(height: 90),
            Image.network(
              weatherProvider.currentWeather?.icon ?? '',
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                    Icons.cloud); // Show a default icon in case of an error
              },
            ),
            const SizedBox(height: 30),
            Text(
              'Current Temperature: ${weatherProvider.currentWeather?.temperature ?? "N/A"}',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text('Current Weather',
                  style: TextStyle(fontSize: 25, color: Colors.black)),
            ),
            Center(
              child: Text(
                  '${weatherProvider.currentWeather?.weatherDescription ?? "N/A"}',
                  style: const TextStyle(fontSize: 25, color: Colors.black)),
            ),
            const SizedBox(height: 60),
            Flexible(
              child: weatherProvider.hourlyForecast.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherProvider.hourlyForecast.length,
                      itemBuilder: (context, index) {
                        final weather = weatherProvider.hourlyForecast[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${weather.temperature}°C',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 35),
                              ),
                              Text(
                                weather.weatherDescription,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 35),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No forecast data available."),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchWeatherWithCurrentLocation(WeatherProvider weatherProvider) async {
    try {
      await requestLocationPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');
      await weatherProvider.fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }
}
