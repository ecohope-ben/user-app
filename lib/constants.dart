import 'package:flutter/material.dart';


final Map<String, String> ageGroup = {
  "18_24": "18-24",
  "25_34": "25-34",
  "35_44": "35-44",
  "45_54": "45-54",
  "55_64": "55-64",
  "65_plus": "65+"
};

double checkNavigationBarHeight(BuildContext context) {
  final bottomPadding = MediaQuery.of(context).padding.bottom;
  final bottomGestureInsets = MediaQuery.of(context).systemGestureInsets.bottom;

  if (bottomPadding > 0) {
    // There is significant bottom padding, likely a button navigation bar is present
    // print("--Button navigation bar is likely present. Height: $bottomPadding");
    return bottomPadding;
  } else if (bottomGestureInsets > 0 && bottomGestureInsets < 48.0) {
    // There are small insets for the gesture bar (e.g., around 14-16 px)
    // print("--Gesture navigation bar is likely present. Height: $bottomGestureInsets");
    return bottomGestureInsets;
  } else {
    // No significant bottom system UI padding detected (e.g., completely hidden)
    // print("--No system navigation bar padding detected.");
    return 0;
  }
}
