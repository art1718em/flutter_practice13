import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_cubit.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_state.dart';
import 'package:flutter_practice13/core/models/favorite_place_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FavoritePlacesCubit>().loadPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные места'),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritePlacesCubit, FavoritePlacesState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    _FilterChip(
                      label: 'Все',
                      isSelected: state.selectedType == null,
                      onTap: () {
                        context.read<FavoritePlacesCubit>().setFilter(null);
                      },
                    ),
                    ...PlaceType.values.map((type) {
                      return _FilterChip(
                        label: '${type.icon} ${type.displayName}',
                        isSelected: state.selectedType == type,
                        onTap: () {
                          context.read<FavoritePlacesCubit>().setFilter(type);
                        },
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: state.filteredPlaces.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 100,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.selectedType == null
                                  ? 'Нет избранных мест'
                                  : 'Нет мест в этой категории',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: state.filteredPlaces.length,
                        itemBuilder: (context, index) {
                          final place = state.filteredPlaces[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  place.type.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              title: Text(
                                place.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(place.type.displayName),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          place.address,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (place.rating > 0) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        ...List.generate(5, (index) {
                                          return Icon(
                                            index < place.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 16,
                                            color: Colors.amber,
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  if (place.phone != null)
                                    const PopupMenuItem(
                                      value: 'call',
                                      child: Row(
                                        children: [
                                          Icon(Icons.phone),
                                          SizedBox(width: 8),
                                          Text('Позвонить'),
                                        ],
                                      ),
                                    ),
                                  const PopupMenuItem(
                                    value: 'navigate',
                                    child: Row(
                                      children: [
                                        Icon(Icons.map),
                                        SizedBox(width: 8),
                                        Text('Открыть карту'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'visited',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check),
                                        SizedBox(width: 8),
                                        Text('Отметить посещение'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Редактировать'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text(
                                          'Удалить',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'call':
                                      if (place.phone != null) {
                                        final uri = Uri.parse('tel:${place.phone}');
                                        if (await canLaunchUrl(uri)) {
                                          launchUrl(uri);
                                        }
                                      }
                                      break;
                                    case 'navigate':
                                      final uri = Uri.parse(
                                        'https://yandex.ru/maps/?text=${Uri.encodeComponent(place.address)}',
                                      );
                                      if (await canLaunchUrl(uri)) {
                                        launchUrl(uri, mode: LaunchMode.externalApplication);
                                      }
                                      break;
                                    case 'visited':
                                      context.read<FavoritePlacesCubit>().markVisited(place.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Посещение отмечено'),
                                        ),
                                      );
                                      break;
                                    case 'edit':
                                      context.push('/places/edit/${place.id}');
                                      break;
                                    case 'delete':
                                      _showDeleteDialog(context, place.id, place.name);
                                      break;
                                  }
                                },
                              ),
                              onTap: () => context.push('/places/details/${place.id}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/places/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String placeId, String placeName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить место?'),
        content: Text('Вы уверены, что хотите удалить "$placeName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritePlacesCubit>().deletePlace(placeId);
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

