import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_cubit.dart';
import 'package:flutter_practice13/features/favorite_places/logic/favorite_places_state.dart';
import 'package:flutter_practice13/core/models/favorite_place_model.dart';

class EditPlaceScreen extends StatefulWidget {
  final String placeId;

  const EditPlaceScreen({
    super.key,
    required this.placeId,
  });

  @override
  State<EditPlaceScreen> createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late PlaceType _selectedType;
  late double _rating;

  @override
  void initState() {
    super.initState();
    final place = context.read<FavoritePlacesCubit>().state.places.firstWhere(
          (p) => p.id == widget.placeId,
        );

    _nameController = TextEditingController(text: place.name);
    _addressController = TextEditingController(text: place.address);
    _phoneController = TextEditingController(text: place.phone ?? '');
    _notesController = TextEditingController(text: place.notes ?? '');
    _selectedType = place.type;
    _rating = place.rating;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      final place = context.read<FavoritePlacesCubit>().state.places.firstWhere(
            (p) => p.id == widget.placeId,
          );

      final updatedPlace = place.copyWith(
        name: _nameController.text.trim(),
        type: _selectedType,
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        rating: _rating,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      context.read<FavoritePlacesCubit>().updatePlace(updatedPlace);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать место'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePlace,
          ),
        ],
      ),
      body: BlocBuilder<FavoritePlacesCubit, FavoritePlacesState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название *',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите название';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<PlaceType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Тип места *',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: PlaceType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text('${type.icon} ${type.displayName}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Адрес *',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите адрес';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Рейтинг',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = (index + 1).toDouble();
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Заметки',
                      prefixIcon: Icon(Icons.note),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _savePlace,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


