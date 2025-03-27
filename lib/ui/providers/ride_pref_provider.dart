import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/asyn_value.dart';

class RidePrefProvider extends ChangeNotifier {
  RidePrefProvider(this._repository) {
    _currentPreference = null;
    fetchPastPreferences();
  }

  final RidePreferencesRepository _repository;
  RidePreference? _currentPreference;
  AsyncValue<List<RidePreference>> _pastPreferences = AsyncValue.loading();

  RidePreference? get currentPreference => _currentPreference;

  AsyncValue<List<RidePreference>> get preferencesHistory => _pastPreferences;

  Future<void> setCurrentPreference(RidePreference newPreference)async {
    //if the new preference is not equal to the current one
    if (_currentPreference != newPreference) {
      _currentPreference = newPreference;
      
      await _repository.addPreference(newPreference);
      fetchPastPreferences();
      notifyListeners();
    }
  }
  
  Future<void> fetchPastPreferences() async {
    _pastPreferences = AsyncValue.loading();
    notifyListeners();

    try{
      List<RidePreference> pastPrefs = await _repository.getPastPreferences();
      _pastPreferences = AsyncValue.success(pastPrefs);
    }
    catch(e){
      _pastPreferences = AsyncValue.errorValue(e);
    }
    notifyListeners();
  }
}
