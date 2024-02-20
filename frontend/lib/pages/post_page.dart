import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tooGoodToWaste/dto/chatroom_model.dart';
import 'package:tooGoodToWaste/service/user_service.dart';
import '../dto/shared_item_model.dart';
import '../dto/user_model.dart';
import 'chatroom.dart';

class PostPage extends StatefulWidget {
  final SharedItem postData;

  const PostPage({
    super.key,
    required this.postData,
  });

  @override
  State<StatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Shared Item Information'),
          actions: const [],
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FractionallySizedBox(
                widthFactor: 1.0,
                child: SizedBox(
                    height: 190,
                    child: GoogleMap(
                      onMapCreated: (event) {},
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.postData.location.latitude,
                            widget.postData.location.longitude),
                        zoom: 15.0,
                      ),
                      circles: <Circle>{
                        Circle(
                            circleId: CircleId(widget.postData.id!),
                            center: LatLng(widget.postData.location.latitude,
                                widget.postData.location.longitude),
                            fillColor: const Color.fromRGBO(79, 195, 247, 0.5),
                            strokeWidth: 1,
                            strokeColor: const Color.fromRGBO(79, 195, 247, 1),
                            radius: 200)
                      },
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.postData.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                  'Amount: ${widget.postData.amount.nominal} ${widget.postData.amount.unit}',
                  style: Theme.of(context).textTheme.headlineSmall),
              // TODO: Insert User name here
              const Spacer(),
              //Add Mock Picture here
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: 
                  // Image.asset('assets/images/food_icons/${foodDetail.category}.png')
                  Image.asset('assets/mock/milk.JPG'),
              ),
              FutureBuilder(
                  future: userService.getUserData(widget.postData.user),
                  builder: (BuildContext context,
                      AsyncSnapshot<TGTWUser> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.done &&
                        userSnapshot.hasData) {
                      TGTWUser user = userSnapshot.data!;

                      return FilledButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatroomPage(
                                          secondUserId: widget.postData.user,
                                          sharedItem: widget.postData,
                                        )));
                          },
                          child: FractionallySizedBox(
                              widthFactor: 1,
                              child: Text(
                                'Chat with ${user.name.last}',
                                textAlign: TextAlign.center,
                              )));
                    } else {
                      return const FilledButton(
                          onPressed: null,
                          child: FractionallySizedBox(
                              widthFactor: 1,
                              child: Text(
                                'Loading',
                                textAlign: TextAlign.center,
                              )));
                    }
                  }),
            ])));
  }
}
