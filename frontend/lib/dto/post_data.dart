import 'package:tooGoodToWaste/dto/user_model.dart';

class PostData {
  final String title;
  final double distance;
  final String measurement;
  final double amount;
  final User user;

  PostData({
    required this.title,
    required this.distance,
    required this.measurement,
    required this.amount,
    required this.user
  });
}