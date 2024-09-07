class CurrentWeatherModel {
  final double temperature;
  final String weatherDescription;
  final String icon;
  final String location;

  CurrentWeatherModel({
    required this.icon,
    required this.location,
    required this.temperature,
    required this.weatherDescription,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] ?? {};
    final condition = current['condition'] ?? {};
    final locationn = json['location'] ?? {};

    return CurrentWeatherModel(
      icon: 'https:${condition['icon']}',
      temperature: current['temp_c']?.toDouble() ?? 0.0,
      weatherDescription: condition['text'] ?? '',
      location: locationn['name']?.toString() ?? '',
    );
  }
}
