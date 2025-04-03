// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_item_reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedItemReservation _$SharedItemReservationFromJson(
        Map<String, dynamic> json) =>
    SharedItemReservation(
      reserver: json['reserver'] as String,
      reservationTime: json['reservation_time'] as int,
    );

Map<String, dynamic> _$SharedItemReservationToJson(
        SharedItemReservation instance) =>
    <String, dynamic>{
      'reserver': instance.reserver,
      'reservation_time': instance.reservationTime,
    };
