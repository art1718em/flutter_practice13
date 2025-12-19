import 'package:flutter_practice13/core/models/favorite_place_model.dart';
import 'package:flutter_practice13/domain/repositories/places_repository.dart';

class UpdatePlaceUseCase {
  final PlacesRepository repository;

  UpdatePlaceUseCase(this.repository);

  Future<void> call(FavoritePlaceModel place) {
    return repository.updatePlace(place);
  }
}

