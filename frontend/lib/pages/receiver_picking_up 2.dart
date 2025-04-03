import 'package:flutter/material.dart';
import 'package:tooGoodToWaste/dto/pickup_process.dart';
import 'package:tooGoodToWaste/dto/shared_item_model.dart';
import 'package:tooGoodToWaste/service/shared_items_service.dart';

class ReceiverPickingUp extends StatefulWidget {
  final PickupProcess pickupProcess;

  const ReceiverPickingUp({super.key, required this.pickupProcess});

  @override
  State<StatefulWidget> createState() => _ReceiverPickingUpState();
}

class _ReceiverPickingUpState extends State<ReceiverPickingUp> {
  final SharedItemService sharedItemService = SharedItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: FutureBuilder(
            future: sharedItemService
                .getSharedItem(widget.pickupProcess.sharedItemId),
            builder:
                (BuildContext context, AsyncSnapshot<SharedItem?> snapshot) {
              if (snapshot.hasData) {
                return Text("Picking Up: ${snapshot.requireData!.name}");
              } else {
                return const Text("Loading");
              }
            },
          )),
    );
  }
}
