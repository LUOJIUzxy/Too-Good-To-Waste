import 'package:json_annotation/json_annotation.dart';

enum PickupState {
  @JsonValue("Initialized")
  INITIALIZED,
  @JsonValue("ReceiverReceives")
  RECEIVER_RECEVICES,
  @JsonValue("Done")
  DONE,
  @JsonValue("Cancelled")
  CANCELLED
}
