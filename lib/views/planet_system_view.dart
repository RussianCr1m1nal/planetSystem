import 'package:flutter/material.dart';
import 'package:planet_system/main.dart';
import 'package:planet_system/models/planet.dart';
import 'package:planet_system/painters/orbits_painter.dart';
import 'package:planet_system/widgets/planet_widget.dart';
import 'dart:math';

class PlanetSystemView extends StatefulWidget {
  const PlanetSystemView({Key? key}) : super(key: key);

  @override
  State<PlanetSystemView> createState() => _PlanetSystemViewState();
}

class _PlanetSystemViewState extends State<PlanetSystemView> {
  List<Planet> planets = [];
  Planet? _furthestPlanet;

  deletePlanet(Planet planet) {
    setState(() {
      planets.remove(planet);

      if (_furthestPlanet == planet) {
        _furthestPlanet = null;
        for (Planet planet in planets){
          _setFurthestPlanet(planet);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox.expand(
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/space_bg.jpg'), fit: BoxFit.cover),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: _planetSystemSize(),
                height: _planetSystemSize(),
                child: Stack(
                  alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: OrbitsPainter(planets),
            ),
            Container(
              width: sunRadius * 2,
              height: sunRadius * 2,
              decoration: const BoxDecoration(                
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
            ...planetsBuilder(planets),
          ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/newPlanet', arguments: planets);
            if (result == null) {
              return;
            }

            final newPlanet = result as Planet;
            planets.add(newPlanet);
            _setFurthestPlanet(newPlanet);
            setState(() {});
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.grey[900]),
    );
  }

  List<Widget> planetsBuilder(List<Planet> planets) {
    final List<Widget> planetWidgetsList = [];

    for (Planet planet in planets) {
      planetWidgetsList.add(PlanetWidget(planet: planet, deletePlanetCallBack: deletePlanet));
    }

    return planetWidgetsList;
  }

  double _planetSystemSize() {
    return max(MediaQuery.of(context).size.width, _sizeFromFurthestPlanet());
  }

  double _sizeFromFurthestPlanet() {
    if (_furthestPlanet == null) {
      return 0;
    }

    return _furthestPlanet!.distanceFromSun * 2 + _furthestPlanet!.radius * 2 + 10;
  }

  void _setFurthestPlanet(Planet planet) {
    if (_furthestPlanet == null) {
      _furthestPlanet = planet;
      return;
    }

    _furthestPlanet = _furthestPlanet!.distanceFromSun < planet.distanceFromSun ? planet : _furthestPlanet;
  }
}