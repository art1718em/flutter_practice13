import 'package:flutter_practice13/core/models/favorite_place_model.dart';
import 'package:flutter_practice13/data/datasources/places/places_local_datasource.dart';
import 'package:flutter_practice13/domain/repositories/places_repository.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesLocalDataSource localDataSource;

  PlacesRepositoryImpl(this.localDataSource);

  @override
  Future<List<FavoritePlaceModel>> getPlaces() {
    return localDataSource.getPlaces();
  }

  @override
  Future<FavoritePlaceModel> getPlaceById(String id) {
    return localDataSource.getPlaceById(id);
  }

  @override
  Future<void> addPlace(FavoritePlaceModel place) {
    return localDataSource.addPlace(place);
  }

  @override
  Future<void> updatePlace(FavoritePlaceModel place) {
    return localDataSource.updatePlace(place);
  }

  @override
  Future<void> deletePlace(String id) {
    return localDataSource.deletePlace(id);
  }
}

