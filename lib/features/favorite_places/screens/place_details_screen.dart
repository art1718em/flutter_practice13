import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_cubit.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_state.dart';
import 'package:flutter_practice13/core/models/favorite_place_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailsScreen({
    super.key,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritePlacesCubit, FavoritePlacesState>(
      builder: (context, state) {
        final place = state.places.firstWhere((p) => p.id == placeId);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Детали места'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/places/edit/$placeId'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          place.type.icon,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        place.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(place.type.displayName),
                      ),
                      if (place.rating > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < place.rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Адрес'),
                  subtitle: Text(place.address),
                  trailing: IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () async {
                      final uri = Uri.parse(
                        'https://yandex.ru/maps/?text=${Uri.encodeComponent(place.address)}',
                      );
                      if (await canLaunchUrl(uri)) {
                        launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ),
                if (place.phone != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Телефон'),
                    subtitle: Text(place.phone!),
                    trailing: IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () async {
                        final uri = Uri.parse('tel:${place.phone}');
                        if (await canLaunchUrl(uri)) {
                          launchUrl(uri);
                        }
                      },
                    ),
                  ),
                ],
                if (place.notes != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.note),
                    title: const Text('Заметки'),
                    subtitle: Text(place.notes!),
                  ),
                ],
                if (place.lastVisit != null) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Последнее посещение'),
                    subtitle: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(place.lastVisit!),
                    ),
                  ),
                ],
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<FavoritePlacesCubit>().markVisited(place.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Посещение отмечено'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Отметить посещение'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

