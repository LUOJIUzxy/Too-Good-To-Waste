import 'package:json_annotation/json_annotation.dart';

part 'shared_item_reservation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SharedItemReservation {
  final String reserver;
  final int reservationTime;

  SharedItemReservation(
      {required this.reserver, required this.reservationTime});

  factory SharedItemReservation.fromJson(Map<String, dynamic> json) =>
      _$SharedItemReservationFromJson(json);

  Map<String, dynamic> toJson() => _$SharedItemReservationToJson(this);
}
