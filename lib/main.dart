import 'package:flutter/material.dart';
import 'package:planet_system/routes/route_generator.dart';

const double sunRadius = 25;

void main() {
  runApp(const PlanetSystemApp());
}

class PlanetSystemApp extends StatelessWidget {
  const PlanetSystemApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Planet system',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}