import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:flutter_practice13/core/storage/database_helper.dart';
import 'package:flutter_practice13/core/storage/preferences_helper.dart';
import 'package:flutter_practice13/core/storage/secure_storage_helper.dart';
import 'package:flutter_practice13/core/api/nhtsa/nhtsa_api_client.dart';
import 'package:flutter_practice13/core/api/countries/countries_api_client.dart';
import 'package:flutter_practice13/data/datasources/vehicle_catalog/vehicle_catalog_datasource.dart';
import 'package:flutter_practice13/data/datasources/countries/countries_datasource.dart';
import 'package:flutter_practice13/data/repositories/vehicle_catalog_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/countries_repository_impl.dart';
import 'package:flutter_practice13/domain/repositories/vehicle_catalog_repository.dart';
import 'package:flutter_practice13/domain/repositories/countries_repository.dart';
import 'package:flutter_practice13/data/datasources/auth/auth_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/vehicles/vehicles_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/expenses/expenses_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/service/service_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/tips/tips_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/places/places_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/profile/profile_local_datasource.dart';
import 'package:flutter_practice13/data/datasources/settings/settings_local_datasource.dart';

import 'package:flutter_practice13/data/repositories/auth_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/vehicles_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/expenses_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/service_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/tips_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/places_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/profile_repository_impl.dart';
import 'package:flutter_practice13/data/repositories/settings_repository_impl.dart';

import 'package:flutter_practice13/domain/repositories/auth_repository.dart';
import 'package:flutter_practice13/domain/repositories/vehicles_repository.dart';
import 'package:flutter_practice13/domain/repositories/expenses_repository.dart';
import 'package:flutter_practice13/domain/repositories/service_repository.dart';
import 'package:flutter_practice13/domain/repositories/tips_repository.dart';
import 'package:flutter_practice13/domain/repositories/places_repository.dart';
import 'package:flutter_practice13/domain/repositories/profile_repository.dart';
import 'package:flutter_practice13/domain/repositories/settings_repository.dart';

import 'package:flutter_practice13/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_practice13/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_practice13/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_practice13/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/get_vehicles_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/add_vehicle_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/update_vehicle_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicles/delete_vehicle_usecase.dart';
import 'package:flutter_practice13/domain/usecases/expenses/get_expenses_usecase.dart';
import 'package:flutter_practice13/domain/usecases/expenses/add_expense_usecase.dart';
import 'package:flutter_practice13/domain/usecases/expenses/delete_expense_usecase.dart';
import 'package:flutter_practice13/domain/usecases/service/get_service_records_usecase.dart';
import 'package:flutter_practice13/domain/usecases/service/add_service_record_usecase.dart';
import 'package:flutter_practice13/domain/usecases/tips/get_tips_usecase.dart';
import 'package:flutter_practice13/domain/usecases/tips/toggle_like_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/get_places_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/add_place_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/update_place_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/delete_place_usecase.dart';
import 'package:flutter_practice13/domain/usecases/profile/get_profile_usecase.dart';
import 'package:flutter_practice13/domain/usecases/profile/update_profile_usecase.dart';
import 'package:flutter_practice13/domain/usecases/settings/get_settings_usecase.dart';
import 'package:flutter_practice13/domain/usecases/settings/update_settings_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_all_makes_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_models_for_make_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_vehicle_types_for_make_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_vehicle_variable_list_usecase.dart';
import 'package:flutter_practice13/domain/usecases/vehicle_catalog/get_vehicle_variable_values_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_all_countries_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_name_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_code_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_country_by_capital_usecase.dart';
import 'package:flutter_practice13/domain/usecases/countries/get_countries_by_region_usecase.dart';

import 'package:flutter_practice13/features/auth/logic/auth_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';
import 'package:flutter_practice13/features/car_expenses/logic/car_expenses_cubit.dart';
import 'package:flutter_practice13/features/service_history/logic/service_history_cubit.dart';
import 'package:flutter_practice13/features/tips/logic/tips_cubit.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_cubit.dart';
import 'package:flutter_practice13/features/profile/logic/profile_cubit.dart';
import 'package:flutter_practice13/features/settings/logic/settings_cubit.dart';
import 'package:flutter_practice13/features/vehicle_catalog/logic/vehicle_catalog_cubit.dart';
import 'package:flutter_practice13/features/vehicle_reference/logic/vehicle_reference_cubit.dart';
import 'package:flutter_practice13/features/countries/logic/countries_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await DatabaseHelper.instance.database;

  final preferencesHelper = await PreferencesHelper.getInstance();
  getIt.registerSingleton<PreferencesHelper>(preferencesHelper);

  final secureStorageHelper = await SecureStorageHelper.getInstance();
  getIt.registerSingleton<SecureStorageHelper>(secureStorageHelper);

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  getIt.registerLazySingleton<NhtsaApiClient>(
    () => NhtsaApiClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<CountriesApiClient>(
    () => CountriesApiClient(getIt<Dio>()),
  );

  getIt.registerLazySingleton<VehicleCatalogDataSource>(
    () => VehicleCatalogDataSource(getIt<NhtsaApiClient>()),
  );

  getIt.registerLazySingleton<CountriesDataSource>(
    () => CountriesDataSource(getIt<CountriesApiClient>()),
  );

  getIt.registerLazySingleton<VehicleCatalogRepository>(
    () => VehicleCatalogRepositoryImpl(getIt<VehicleCatalogDataSource>()),
  );

  getIt.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(getIt<CountriesDataSource>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<SecureStorageHelper>()),
  );
  getIt.registerLazySingleton<VehiclesLocalDataSource>(
    () => VehiclesLocalDataSource(getIt<SecureStorageHelper>()),
  );
  getIt.registerLazySingleton<ExpensesLocalDataSource>(
    () => ExpensesLocalDataSource(getIt<SecureStorageHelper>()),
  );
  getIt.registerLazySingleton<ServiceLocalDataSource>(
    () => ServiceLocalDataSource(getIt<SecureStorageHelper>()),
  );
  getIt.registerLazySingleton<TipsLocalDataSource>(() => TipsLocalDataSource());
  getIt.registerLazySingleton<PlacesLocalDataSource>(
    () => PlacesLocalDataSource(getIt<SecureStorageHelper>()),
  );
  getIt.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(getIt<SecureStorageHelper>()),
  );
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(getIt<PreferencesHelper>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthLocalDataSource>()),
  );
  getIt.registerLazySingleton<VehiclesRepository>(
    () => VehiclesRepositoryImpl(getIt<VehiclesLocalDataSource>()),
  );
  getIt.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(getIt<ExpensesLocalDataSource>()),
  );
  getIt.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(getIt<ServiceLocalDataSource>()),
  );
  getIt.registerLazySingleton<TipsRepository>(
    () => TipsRepositoryImpl(getIt<TipsLocalDataSource>()),
  );
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(getIt<PlacesLocalDataSource>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileLocalDataSource>()),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );

  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetCurrentUserUseCase(getIt<AuthRepository>()));

  getIt.registerFactory(() => GetVehiclesUseCase(getIt<VehiclesRepository>()));
  getIt.registerFactory(() => AddVehicleUseCase(getIt<VehiclesRepository>()));
  getIt.registerFactory(() => UpdateVehicleUseCase(getIt<VehiclesRepository>()));
  getIt.registerFactory(() => DeleteVehicleUseCase(getIt<VehiclesRepository>()));

  getIt.registerFactory(() => GetExpensesUseCase(getIt<ExpensesRepository>()));
  getIt.registerFactory(() => AddExpenseUseCase(getIt<ExpensesRepository>()));
  getIt.registerFactory(() => DeleteExpenseUseCase(getIt<ExpensesRepository>()));

  getIt.registerFactory(() => GetServiceRecordsUseCase(getIt<ServiceRepository>()));
  getIt.registerFactory(() => AddServiceRecordUseCase(getIt<ServiceRepository>()));

  getIt.registerFactory(() => GetTipsUseCase(getIt<TipsRepository>()));
  getIt.registerFactory(() => ToggleLikeUseCase(getIt<TipsRepository>()));

  getIt.registerFactory(() => GetPlacesUseCase(getIt<PlacesRepository>()));
  getIt.registerFactory(() => AddPlaceUseCase(getIt<PlacesRepository>()));
  getIt.registerFactory(() => UpdatePlaceUseCase(getIt<PlacesRepository>()));
  getIt.registerFactory(() => DeletePlaceUseCase(getIt<PlacesRepository>()));

  getIt.registerFactory(() => GetProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerFactory(() => UpdateProfileUseCase(getIt<ProfileRepository>()));

  getIt.registerFactory(() => GetSettingsUseCase(getIt<SettingsRepository>()));
  getIt.registerFactory(() => UpdateSettingsUseCase(getIt<SettingsRepository>()));

  getIt.registerFactory(() => GetAllMakesUseCase(getIt<VehicleCatalogRepository>()));
  getIt.registerFactory(() => GetModelsForMakeUseCase(getIt<VehicleCatalogRepository>()));
  getIt.registerFactory(() => GetVehicleTypesForMakeUseCase(getIt<VehicleCatalogRepository>()));
  getIt.registerFactory(() => GetVehicleVariableListUseCase(getIt<VehicleCatalogRepository>()));
  getIt.registerFactory(() => GetVehicleVariableValuesUseCase(getIt<VehicleCatalogRepository>()));

  getIt.registerFactory(() => GetAllCountriesUseCase(getIt<CountriesRepository>()));
  getIt.registerFactory(() => GetCountryByNameUseCase(getIt<CountriesRepository>()));
  getIt.registerFactory(() => GetCountryByCodeUseCase(getIt<CountriesRepository>()));
  getIt.registerFactory(() => GetCountryByCapitalUseCase(getIt<CountriesRepository>()));
  getIt.registerFactory(() => GetCountriesByRegionUseCase(getIt<CountriesRepository>()));

  getIt.registerFactory(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => VehiclesCubit(
      getVehiclesUseCase: getIt<GetVehiclesUseCase>(),
      addVehicleUseCase: getIt<AddVehicleUseCase>(),
      updateVehicleUseCase: getIt<UpdateVehicleUseCase>(),
      deleteVehicleUseCase: getIt<DeleteVehicleUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => CarExpensesCubit(
      getExpensesUseCase: getIt<GetExpensesUseCase>(),
      addExpenseUseCase: getIt<AddExpenseUseCase>(),
      deleteExpenseUseCase: getIt<DeleteExpenseUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => ServiceHistoryCubit(
      getServiceRecordsUseCase: getIt<GetServiceRecordsUseCase>(),
      addServiceRecordUseCase: getIt<AddServiceRecordUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => TipsCubit(
      getTipsUseCase: getIt<GetTipsUseCase>(),
      toggleLikeUseCase: getIt<ToggleLikeUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => FavoritePlacesCubit(
      getPlacesUseCase: getIt<GetPlacesUseCase>(),
      addPlaceUseCase: getIt<AddPlaceUseCase>(),
      updatePlaceUseCase: getIt<UpdatePlaceUseCase>(),
      deletePlaceUseCase: getIt<DeletePlaceUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => SettingsCubit(
      getSettingsUseCase: getIt<GetSettingsUseCase>(),
      updateSettingsUseCase: getIt<UpdateSettingsUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => VehicleCatalogCubit(
      getAllMakesUseCase: getIt<GetAllMakesUseCase>(),
      getModelsForMakeUseCase: getIt<GetModelsForMakeUseCase>(),
      getVehicleTypesForMakeUseCase: getIt<GetVehicleTypesForMakeUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => VehicleReferenceCubit(
      getVehicleVariableListUseCase: getIt<GetVehicleVariableListUseCase>(),
      getVehicleVariableValuesUseCase: getIt<GetVehicleVariableValuesUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => CountriesCubit(
      getAllCountriesUseCase: getIt<GetAllCountriesUseCase>(),
      getCountryByNameUseCase: getIt<GetCountryByNameUseCase>(),
      getCountryByCodeUseCase: getIt<GetCountryByCodeUseCase>(),
      getCountryByCapitalUseCase: getIt<GetCountryByCapitalUseCase>(),
      getCountriesByRegionUseCase: getIt<GetCountriesByRegionUseCase>(),
    ),
  );
}

