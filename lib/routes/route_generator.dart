
import 'package:flutter/material.dart';
import 'package:planet_system/models/planet.dart';
import 'package:planet_system/views/new_planet_view.dart';
import 'package:planet_system/views/planet_system_view.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const PlanetSystemView());
      case '/newPlanet':
        return MaterialPageRoute(builder: (_) => NewPlanetView(planets: arguments as List<Planet>));
      default:
        throw Exception('Unknown route name');
    }
  }
}