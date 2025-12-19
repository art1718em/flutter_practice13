import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice13/features/auth/logic/auth_cubit.dart';
import 'package:flutter_practice13/features/auth/logic/auth_state.dart';
import 'package:flutter_practice13/features/car_expenses/logic/car_expenses_cubit.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_cubit.dart';
import 'package:flutter_practice13/features/profile/logic/profile_cubit.dart';
import 'package:flutter_practice13/features/profile/logic/profile_state.dart';
import 'package:flutter_practice13/features/service_history/logic/service_history_cubit.dart';
import 'package:flutter_practice13/features/vehicles/logic/vehicles_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        final profile = profileState.profile;

        if (profile == null) {
          return const Scaffold(
            body: Center(child: Text('Загрузка профиля...')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Редактировать профиль',
                onPressed: () => context.push('/profile/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Настройки',
                onPressed: () => context.push('/settings'),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Выйти',
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.read<ProfileCubit>().clearProfile();
                  context.read<VehiclesCubit>().clearVehicles();
                  context.read<CarExpensesCubit>().clearExpenses();
                  context.read<ServiceHistoryCubit>().clearServiceHistory();
                  context.read<FavoritePlacesCubit>().clearPlaces();
                  context.go('/auth/login');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profile.avatar != null
                        ? CachedNetworkImageProvider(profile.avatar!)
                        : null,
                    child: profile.avatar == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Телефон'),
                  subtitle: Text(profile.phone ?? 'Не указан'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Водительское удостоверение'),
                  subtitle: Text(profile.drivingLicenseNumber ?? 'Не указано'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.timeline),
                  title: const Text('Стаж вождения'),
                  subtitle: Text(
                    profile.drivingExperienceYears != null
                        ? '${profile.drivingExperienceYears} ${_getYearWord(profile.drivingExperienceYears!)}'
                        : 'Не указан',
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getYearWord(int years) {
    if (years % 10 == 1 && years % 100 != 11) {
      return 'год';
    } else if ([2, 3, 4].contains(years % 10) && ![12, 13, 14].contains(years % 100)) {
      return 'года';
    } else {
      return 'лет';
    }
  }
}

