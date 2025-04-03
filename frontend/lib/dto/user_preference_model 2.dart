import 'package:json_annotation/json_annotation.dart';

part 'user_preference_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPreference {
  final UnitPreference unitPreference;
  final FoodPreference? foodPreference;

  const UserPreference(
      {this.unitPreference = UnitPreference.KM, this.foodPreference});

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferenceToJson(this);
}

enum FoodPreference {
  @JsonValue("vegetarian")
  Vegetarian,
  @JsonValue("vegan")
  Vegan
}

enum UnitPreference {
  @JsonValue("km")
  KM,
  @JsonValue("mile")
  MILE
}
