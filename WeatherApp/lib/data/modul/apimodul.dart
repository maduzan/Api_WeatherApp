class WeatherResponse {
  final List<WeatherData> hourlyForecast;

  WeatherResponse({required this.hourlyForecast});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final forecast =
        json['forecast']?['forecastday']?[0]?['hour'] as List? ?? [];
    return WeatherResponse(
      hourlyForecast:
          forecast.map((item) => WeatherData.fromJson(item)).toList(),
    );
  }
}

class WeatherData {
  final DateTime dateTime;
  final double temperature;
  final String weatherDescription;

  WeatherData({
    required this.dateTime,
    required this.temperature,
    required this.weatherDescription,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final time = json['time'] ?? '';
    final temp = json['temp_c']?.toDouble() ?? 0.0;
    final condition = json['condition'] ?? {};
    final description = condition['text'] ?? '';

    return WeatherData(
      dateTime: DateTime.parse(time),
      temperature: temp,
      weatherDescription: description,
    );
  }
}
