import 'package:planet_system/models/planet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {

  void savePlanets(List<Planet> planets) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setStringList('planets', planets.map((planet) => planet.toJson()).toList());
  }

  Future<List<Planet>?> getSavedPlanets() async {
    final preferences = await SharedPreferences.getInstance();
  
    final planets = preferences.getStringList('planets')?.map((planetJson) => Planet.fromJson(planetJson)).toList();

    return planets;
  }
}