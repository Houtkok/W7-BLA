import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/ui/providers/asyn_value.dart';
import 'package:week_3_blabla_project/ui/providers/ride_pref_provider.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/widgets/errors/bla_error_screen.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch the RidePrefProvider
    final ridePrefProvider =
        Provider.of<RidePrefProvider>(context, listen: false);
    RidePreference? currentRidePreference = ridePrefProvider.currentPreference;
    AsyncValue<List<RidePreference>> pastPreferences =
        ridePrefProvider.preferencesHistory;

    onRidePrefSelected(RidePreference newPreference) async {
      //read the ridePrefProvider
      final ridePrefProvider =
          Provider.of<RidePrefProvider>(context, listen: false);

      //call the provider setCurrentPreference
      ridePrefProvider.setCurrentPreference(newPreference);

      await Navigator.of(context)
          .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
    }

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(BlaSpacings.m),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 2.1 Display the Form to input the ride preferences
                        RidePrefForm(
                            initialPreference: currentRidePreference,
                            onSubmit: onRidePrefSelected),
                        SizedBox(height: BlaSpacings.m),
                                  
                        // 2.2 Optionally display a list of past preferences
                        if (pastPreferences.isLoading)
                          const BlaError(message: 'Loading...')
                        else if (pastPreferences.error != null)
                          const BlaError(message: 'No connection...')
                        else if (pastPreferences.data != null)
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true, // Fix ListView height issue
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: pastPreferences.data!.length,
                              itemBuilder: (ctx, index) => RidePrefHistoryTile(
                                ridePref: pastPreferences.data![index],
                                onPressed: () =>
                                    onRidePrefSelected(pastPreferences.data![index]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
