import 'package:flutter_practice13/core/models/user_profile_model.dart';
import 'package:flutter_practice13/data/datasources/profile/user_profile_dto.dart';

extension UserProfileMapper on UserProfileDto {
  UserProfileModel toModel() {
    return UserProfileModel(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      drivingLicenseNumber: drivingLicenseNumber,
      drivingExperienceYears: drivingExperienceYears,
    );
  }
}

extension UserProfileModelMapper on UserProfileModel {
  UserProfileDto toDto() {
    return UserProfileDto(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      drivingLicenseNumber: drivingLicenseNumber,
      drivingExperienceYears: drivingExperienceYears,
    );
  }
}

