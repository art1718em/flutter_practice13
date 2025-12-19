import 'package:flutter/material.dart';
import 'package:flutter_practice13/features/auth/screens/splash_screen.dart';
import 'package:flutter_practice13/features/auth/screens/login_screen.dart';
import 'package:flutter_practice13/features/auth/screens/register_screen.dart';
import 'package:flutter_practice13/features/car_expenses/screens/add_expense_screen.dart';
import 'package:flutter_practice13/features/favorite_places/screens/add_place_screen.dart';
import 'package:flutter_practice13/features/favorite_places/screens/edit_place_screen.dart';
import 'package:flutter_practice13/features/favorite_places/screens/place_details_screen.dart';
import 'package:flutter_practice13/features/navigation/main_screen.dart';
import 'package:flutter_practice13/features/profile/screens/edit_profile_screen.dart';
import 'package:flutter_practice13/features/service_history/screens/add_service_record_screen.dart';
import 'package:flutter_practice13/features/service_history/screens/service_history_screen.dart';
import 'package:flutter_practice13/features/settings/screens/settings_screen.dart';
import 'package:flutter_practice13/features/tips/screens/tip_detail_screen.dart';
import 'package:flutter_practice13/features/vehicles/screens/add_vehicle_screen.dart';
import 'package:flutter_practice13/features/vehicles/screens/edit_vehicle_screen.dart';
import 'package:flutter_practice13/features/vehicles/screens/vehicle_details_screen.dart';
import 'package:flutter_practice13/features/vehicles/screens/vehicles_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        final tabParam = state.uri.queryParameters['tab'];
        int initialIndex = 0;
        if (tabParam != null) {
          initialIndex = int.tryParse(tabParam) ?? 0;
        }
        return MainScreen(initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/vehicles',
      builder: (context, state) => const VehiclesScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddVehicleScreen(),
        ),
        GoRoute(
          path: 'edit/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EditVehicleScreen(vehicleId: id);
          },
        ),
        GoRoute(
          path: 'details/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return VehicleDetailsScreen(vehicleId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/expenses/add',
      builder: (BuildContext context, GoRouterState state) {
        return const AddExpenseScreen();
      },
    ),
    GoRoute(
      path: '/tips/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TipDetailScreen(tipId: id);
      },
    ),
    GoRoute(
      path: '/places/add',
      builder: (context, state) => const AddPlaceScreen(),
    ),
    GoRoute(
      path: '/places/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EditPlaceScreen(placeId: id);
      },
    ),
    GoRoute(
      path: '/places/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PlaceDetailsScreen(placeId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (BuildContext context, GoRouterState state) {
        return const ServiceHistoryScreen();
      },
      routes: [
        GoRoute(
          path: 'add',
          builder: (BuildContext context, GoRouterState state) {
            return const AddServiceRecordScreen();
          },
        ),
      ],
    ),
  ],
);

