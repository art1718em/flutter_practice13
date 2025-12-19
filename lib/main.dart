import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/di/injection_container.dart';
import 'package:flutter_practice13/features/auth/logic/auth_cubit.dart';
import 'package:flutter_practice13/features/profile/logic/profile_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/car_expenses/logic/car_expenses_cubit.dart';
import 'package:flutter_practice13/features/service_history/logic/service_history_cubit.dart';
import 'package:flutter_practice13/features/tips/logic/tips_cubit.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_cubit.dart';
import 'package:flutter_practice13/features/vehicle_reference/logic/vehicle_reference_cubit.dart';
import 'package:flutter_practice13/features/navigation/app_router.dart';
import 'package:flutter_practice13/features/settings/logic/settings_state.dart';
import 'package:flutter_practice13/core/models/app_settings_model.dart';
import 'package:flutter_practice13/shared/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<VehiclesCubit>()),
        BlocProvider(create: (context) => getIt<CarExpensesCubit>()),
        BlocProvider(create: (context) => getIt<ServiceHistoryCubit>()),
        BlocProvider(create: (context) => getIt<TipsCubit>()),
        BlocProvider(create: (context) => getIt<FavoritePlacesCubit>()),
        BlocProvider(create: (context) => getIt<SettingsCubit>()),
        BlocProvider(create: (context) => getIt<VehicleCatalogCubit>()),
        BlocProvider(create: (context) => getIt<VehicleReferenceCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final themeMode = settingsState.settings.themeMode;
          
          return MaterialApp.router(
            title: 'Автомобильный помощник',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getFlutterThemeMode(themeMode),
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  ThemeMode _getFlutterThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
