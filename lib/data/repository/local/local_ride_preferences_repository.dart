import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ride_preferences_dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/location/locations.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository implements RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Get the string list form the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    // Convert the string list to a list of RidePreferences – Using map()
    return prefsList
        .map((json) => RidePreferencesDto.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    List<RidePreference> preferences = await getPastPreferences();
    preferences.add(preference);

    final List<String> jsonList = preferences
        .map((pref) => jsonEncode(RidePreferencesDto.toJson(pref)))
        .toList();

    await prefs.setStringList(_preferencesKey, jsonList);
  }

  RidePreference _ridePreferenceFromJson(Map<String, dynamic> json) {
    return RidePreference(
      departure: Location(
        name: json['departure'],
        country: json['country'],
      ),
      departureDate: DateTime.parse(json['departureDate']),
      arrival: Location(
        name: json['arrival'],
        country: json['country'],
      ),
      requestedSeats: json['requestedSeats'],
    );
  }
}
