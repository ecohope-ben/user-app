import 'package:flutter/foundation.dart';

/// Global notifier to signal that profile was updated.
/// Increment [profileRefreshNotifier].value to trigger listeners (e.g. Home) to refresh ProfileCubit.
final profileRefreshNotifier = ValueNotifier<int>(0);
final subscriptionRefreshNotifier = ValueNotifier<int>(0);
