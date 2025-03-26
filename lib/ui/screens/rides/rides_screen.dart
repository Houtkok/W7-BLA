import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/ride_pref_provider.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the RidePrefProvider
    final ridePrefProvider = Provider.of<RidePrefProvider>(context);
    RidePreference? currentPreference = ridePrefProvider.currentPreference;

    List<Ride> matchingRides = [];

    void onBackPressed() {
      // 1 - Back to the previous view
      Navigator.of(context).pop();
    }

    void onPreferencePressed() async {
      // Open a modal to edit the ride preferences
      RidePreference? newPreference = await Navigator.of(
        context,
      ).push<RidePreference>(
        AnimationUtils.createTopToBottomRoute(
          RidePrefModal(initialPreference: currentPreference),
        ),
      );

      if (newPreference != null) {
        // 1 - Update the current preference
        // final ridePrefProvider = Provider.of<RidePrefProvider>(context, listen: false);
        ridePrefProvider.setCurrentPreference(newPreference);
      }
    }

    void onFilterPressed() {}

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            if (currentPreference != null)
              RidePrefBar(
                ridePreference: currentPreference,
                onBackPressed: onBackPressed,
                onPreferencePressed: onPreferencePressed,
                onFilterPressed: onFilterPressed,
              ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
