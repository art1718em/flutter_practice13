import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/core/models/favorite_place_model.dart';
import 'package:flutter_practice13/domain/usecases/places/get_places_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/add_place_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/update_place_usecase.dart';
import 'package:flutter_practice13/domain/usecases/places/delete_place_usecase.dart';
import 'favorite_places_state.dart';

class FavoritePlacesCubit extends Cubit<FavoritePlacesState> {
  final GetPlacesUseCase getPlacesUseCase;
  final AddPlaceUseCase addPlaceUseCase;
  final UpdatePlaceUseCase updatePlaceUseCase;
  final DeletePlaceUseCase deletePlaceUseCase;

  FavoritePlacesCubit({
    required this.getPlacesUseCase,
    required this.addPlaceUseCase,
    required this.updatePlaceUseCase,
    required this.deletePlaceUseCase,
  }) : super(const FavoritePlacesState());

  Future<void> loadPlaces() async {
    try {
      final places = await getPlacesUseCase();
      emit(state.copyWith(places: places));
    } catch (e) {
      emit(state.copyWith(places: []));
    }
  }

  Future<void> addPlace({
    required String name,
    required PlaceType type,
    required String address,
    String? phone,
    double rating = 0.0,
    String? notes,
  }) async {
    final newPlace = FavoritePlaceModel(
      id: '',
      name: name,
      type: type,
      address: address,
      phone: phone,
      rating: rating,
      notes: notes,
    );

    try {
      await addPlaceUseCase(newPlace);
      await loadPlaces();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePlace(FavoritePlaceModel updatedPlace) async {
    try {
      await updatePlaceUseCase(updatedPlace);
      await loadPlaces();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlace(String id) async {
    try {
      await deletePlaceUseCase(id);
      await loadPlaces();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markVisited(String id) async {
    try {
      final places = await getPlacesUseCase();
      final place = places.firstWhere((p) => p.id == id);
      final updatedPlace = place.copyWith(lastVisit: DateTime.now());
      await updatePlaceUseCase(updatedPlace);
      await loadPlaces();
    } catch (e) {
      rethrow;
    }
  }

  void setFilter(PlaceType? type) {
    emit(state.copyWith(selectedType: type, clearFilter: type == null));
  }

  void clearPlaces() {
    emit(const FavoritePlacesState());
  }
}
