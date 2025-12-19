import 'package:flutter_practice13/core/models/favorite_place_model.dart';
import 'package:flutter_practice13/data/datasources/places/favorite_place_dto.dart';

extension FavoritePlaceMapper on FavoritePlaceDto {
  FavoritePlaceModel toModel() {
    return FavoritePlaceModel(
      id: id,
      name: name,
      type: PlaceType.values.firstWhere((e) => e.name == type),
      address: address,
      phone: phone,
      rating: rating,
      notes: notes,
      lastVisit: lastVisit != null ? DateTime.parse(lastVisit!) : null,
    );
  }
}

extension FavoritePlaceModelMapper on FavoritePlaceModel {
  FavoritePlaceDto toDto() {
    return FavoritePlaceDto(
      id: id,
      name: name,
      type: type.name,
      address: address,
      phone: phone,
      rating: rating,
      notes: notes,
      lastVisit: lastVisit?.toIso8601String(),
    );
  }
}

