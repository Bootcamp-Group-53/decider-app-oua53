import 'package:decider_app/src/core/constants/app_route_constants.dart';
import 'package:decider_app/src/views/screens/option_list_screen.dart';
import 'package:flutter/material.dart';

import '../../views/screens/decider_history_screen.dart';
import '../../views/screens/decider_list_screen.dart';
import '../../views/screens/action_screen.dart';
import '../../views/screens/splash_screen.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteConstants.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteConstants.deciderListScreen:
        return MaterialPageRoute(builder: (_) => const DeciderListScreen());
      case RouteConstants.deciderHistoryScreen:
        return MaterialPageRoute(builder: (_) => const DeciderHistoryScreen());
      case RouteConstants.optionListScreen:
        return MaterialPageRoute(
            builder: (_) => OptionListScreen(
                  model: args as Map<String, dynamic>,
                ));
      case RouteConstants.actionScreen:
        return MaterialPageRoute(
            builder: (_) => ActionScreen(
                  widget: args as Widget,
                ));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
