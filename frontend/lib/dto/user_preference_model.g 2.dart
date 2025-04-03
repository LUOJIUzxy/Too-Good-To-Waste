// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreference _$UserPreferenceFromJson(Map<String, dynamic> json) =>
    UserPreference(
      unitPreference: $enumDecodeNullable(
              _$UnitPreferenceEnumMap, json['unit_preference']) ??
          UnitPreference.KM,
      foodPreference:
          $enumDecodeNullable(FoodPreferenceEnumMap, json['food_preference']),
    );

Map<String, dynamic> _$UserPreferenceToJson(UserPreference instance) =>
    <String, dynamic>{
      'unit_preference': _$UnitPreferenceEnumMap[instance.unitPreference]!,
      'food_preference': FoodPreferenceEnumMap[instance.foodPreference],
    };

const _$UnitPreferenceEnumMap = {
  UnitPreference.KM: 'km',
  UnitPreference.MILE: 'mile',
};

const FoodPreferenceEnumMap = {
  FoodPreference.Vegetarian: 'vegetarian',
  FoodPreference.Vegan: 'vegan',
};
