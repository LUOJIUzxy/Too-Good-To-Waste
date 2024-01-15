// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedItem _$SharedItemFromJson(Map<String, dynamic> json) => SharedItem(
      amount: UserItemAmount.fromJson(json['amount'] as Map<String, dynamic>),
      buyDate: DateTime.parse(json['buy_date'] as String),
      itemRef: json['item_ref'] as String,
      location: const GeoPointConverter()
          .fromJson(json['location'] as Map<String, dynamic>),
      name: json['name'] as String,
      category: json['category'] as String,
      user: PublicUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SharedItemToJson(SharedItem instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'buy_date': instance.buyDate.toIso8601String(),
      'item_ref': instance.itemRef,
      'location': const GeoPointConverter().toJson(instance.location),
      'name': instance.name,
      'category': instance.category,
      'user': instance.user,
    };
