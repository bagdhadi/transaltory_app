import 'package:flutter_application_1/router/route_utils.dart';
import 'package:flutter_application_1/services/app_service.dart';
import 'package:flutter_application_1/views/error_page.dart';
import 'package:flutter_application_1/views/home_page.dart';
import 'package:flutter_application_1/views/login_page.dart';
import 'package:flutter_application_1/views/onboarding_page.dart';
import 'package:flutter_application_1/views/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  final AppService appService;
  late final GoRouter router;

  AppRouter(this.appService) {
    router = GoRouter(
      refreshListenable: appService,
      initialLocation: APP_PAGE.home.toPath,
      routes: [
        GoRoute(
          path: APP_PAGE.home.toPath,
          name: APP_PAGE.home.toName,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: APP_PAGE.splash.toPath,
          name: APP_PAGE.splash.toName,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: APP_PAGE.login.toPath,
          name: APP_PAGE.login.toName,
          builder: (context, state) => const LogInPage(),
        ),
        GoRoute(
          path: APP_PAGE.onBoarding.toPath,
          name: APP_PAGE.onBoarding.toName,
          builder: (context, state) => const OnBoardingPage(),
        ),
        GoRoute(
          path: APP_PAGE.error.toPath,
          name: APP_PAGE.error.toName,
          builder: (context, state) => ErrorPage(error: state.extra.toString()),
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) =>
          ErrorPage(error: state.error.toString()),
      redirect: (context, GoRouterState state) {
        final loginLocation = state.namedLocation(APP_PAGE.login.toName);
        final homeLocation = state.namedLocation(APP_PAGE.home.toName);
        final splashLocation = state.namedLocation(APP_PAGE.splash.toName);
        final onboardLocation = state.namedLocation(APP_PAGE.onBoarding.toName);

        final isLoggedIn = appService.loginState;
        final isInitialized = appService.initialized;
        final isOnboarded = appService.onboarding;

        final isGoingToLogin = state.location == loginLocation;
        final isGoingToInit = state.location == splashLocation;
        final isGoingToOnboard = state.location == onboardLocation;

        if (!isInitialized && !isGoingToInit) {
          return splashLocation;
        } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
          return onboardLocation;
        } else if (isInitialized &&
            isOnboarded &&
            !isLoggedIn &&
            !isGoingToLogin) {
          return loginLocation;
        } else if ((isLoggedIn && isGoingToLogin) ||
            (isInitialized && isGoingToInit) ||
            (isOnboarded && isGoingToOnboard)) {
          return homeLocation;
        }

        return null;
      },
    );
  }
}
