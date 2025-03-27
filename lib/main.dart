import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/repository/local/local_ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/ride_pref_provider.dart';

import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';

void main() {
  // 1 - Initialize the services
  // RidePrefService.initialize(MockRidePreferencesRepository());
  // LocationsService.initialize(MockLocationsRepository());
  // RidesService.initialize(MockRidesRepository());

  // 2- Run the UI
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RidePrefProvider(LocalRidePreferencesRepository()),
        ),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(body: RidePrefScreen()),
    ));
  }
}
