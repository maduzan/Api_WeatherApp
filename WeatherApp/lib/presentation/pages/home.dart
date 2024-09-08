import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/providers/pproviders.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      weatherProvider.fetchWeather(6.04, 80.22);
      fetchWeatherWithCurrentLocation(weatherProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
              child: Text(
            'Weather',
            style: TextStyle(color: Colors.white),
          ))),
      body: Column(
        children: [
          SizedBox(height: 90),
          Image.network(
            weatherProvider.currentWeather?.icon ??
                'https://yourdefaulticonurl.com/default.png',
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                  Icons.cloud); // Show a default icon in case of an error
            },
          ),
          SizedBox(height: 30),
          Text(
            'Current Temperature: ${weatherProvider.currentWeather?.temperature ?? "N/A"}',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          SizedBox(height: 20),
          Center(
            child: Text('Current Weather',
                style: TextStyle(fontSize: 25, color: Colors.white)),
          ),
          Center(
            child: Text(
                '${weatherProvider.currentWeather?.weatherDescription ?? "N/A"}',
                style: TextStyle(fontSize: 25, color: Colors.white)),
          ),
          SizedBox(height: 60),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                            Text(
                              weather.weatherDescription,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text("No forecast data available."),
                  ),
          ),
        ],
      ),
    );
  }

  void fetchWeatherWithCurrentLocation(WeatherProvider weatherProvider) async {
    try {
      await checkLocationSettings();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await weatherProvider.fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> checkLocationSettings() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      // Prompt user to enable location services
      print('Please enable location services.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where the user denies the location permission
        print('Location permission is denied.');
        return;
      }
    }
  }
}
