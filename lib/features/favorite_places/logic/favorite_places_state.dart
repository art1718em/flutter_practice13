import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/core/models/favorite_place_model.dart';

class FavoritePlacesState extends Equatable {
  final List<FavoritePlaceModel> places;
  final PlaceType? selectedType;

  const FavoritePlacesState({
    this.places = const [],
    this.selectedType,
  });

  List<FavoritePlaceModel> get filteredPlaces {
    if (selectedType == null) {
      return places;
    }
    return places.where((place) => place.type == selectedType).toList();
  }

  FavoritePlacesState copyWith({
    List<FavoritePlaceModel>? places,
    PlaceType? selectedType,
    bool clearFilter = false,
  }) {
    return FavoritePlacesState(
      places: places ?? this.places,
      selectedType: clearFilter ? null : selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [places, selectedType];
}


