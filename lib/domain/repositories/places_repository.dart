import 'package:flutter_practice13/core/models/favorite_place_model.dart';

abstract class PlacesRepository {
  Future<List<FavoritePlaceModel>> getPlaces();
  Future<FavoritePlaceModel> getPlaceById(String id);
  Future<void> addPlace(FavoritePlaceModel place);
  Future<void> updatePlace(FavoritePlaceModel place);
  Future<void> deletePlace(String id);
}

