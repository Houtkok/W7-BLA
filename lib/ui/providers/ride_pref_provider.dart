import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidePrefProvider extends ChangeNotifier {
  RidePrefProvider(this._repository) {
    _currentPreference = null;
    _pastPreferences = _repository.getPastPreferences();
  }

  final RidePreferencesRepository _repository;
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  RidePreference? get currentPreference => _currentPreference;
  // the past preferences from the newest to the latest
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();

  void setCurrentPreference(RidePreference newPreference) {
    //if the new preference is not equal to the current one
    if (_currentPreference != newPreference) {
      _currentPreference = newPreference;
      //history shall not be duplicate
      if (!_pastPreferences.contains(newPreference)) {
        _pastPreferences.insert(0, newPreference);
        _repository.addPreference(newPreference);
      }
      notifyListeners();
    }
  }
}
