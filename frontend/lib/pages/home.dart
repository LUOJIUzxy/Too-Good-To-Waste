import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:tooGoodToWaste/dto/item_allergies_enum.dart';
import 'package:tooGoodToWaste/dto/item_category_enum.dart';
import 'package:tooGoodToWaste/dto/shared_item_model.dart';
import 'package:tooGoodToWaste/service/user_location_service.dart';
import 'package:tooGoodToWaste/service/user_service.dart';
import 'package:tooGoodToWaste/widgets/allergies_picker.dart';
import 'package:tooGoodToWaste/widgets/category_picker.dart';
import '../Pages/post_page.dart';
import '../dto/user_model.dart';
import '../service/shared_items_service.dart';

Logger logger = Logger();

// The social places timeline
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      throw StateError("Trying to access user page without authentication");
    }

    final UserService userService = UserService();

    var users = [];
    var postData = [];

    return FutureBuilder(
        future: userService.getUserData(userId),
        builder:
            (BuildContext context, AsyncSnapshot<TGTWUser> userDataSnapshot) {
          if (userDataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userDataSnapshot.hasError) {
            return Center(
              child: Text('Error: ${userDataSnapshot.error}'),
            );
          }

          final TGTWUser user = userDataSnapshot.requireData;

          return FutureBuilder(
            future: UserLocationService.getUserLocation(),
            builder: (BuildContext locationContext,
                AsyncSnapshot<LocationData> locationDataSnapshot) {
              if (locationDataSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (locationDataSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${locationDataSnapshot.error}'),
                );
              }

              final double? longitude =
                  locationDataSnapshot.requireData.longitude;
              final double? latitude =
                  locationDataSnapshot.requireData.latitude;
              if (longitude == null) {
                throw Exception('User longitude is null');
              }
              if (latitude == null) {
                throw Exception('User latitude is null');
              }

              final GeoPoint userLocation = GeoPoint(latitude, longitude);

              return InnerHomeWidget(userLocation: userLocation);
            },
          );
        });
  }
}

class InnerHomeWidget extends StatefulWidget {
  final GeoPoint userLocation;

  const InnerHomeWidget({super.key, required this.userLocation});

  @override
  State<StatefulWidget> createState() => _InnerHomeState();
}

class _InnerHomeState extends State<InnerHomeWidget> {
  final SharedItemService sharedItemService = SharedItemService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  double radius = 1;
  ItemCategory? category;
  List<ItemAllergy> allergies = [];

  Future<void> _showRangeDialog() async {
    final double? selectedRadius = await showDialog<double>(
        context: context,
        builder: (context) => RadiusPicker(initialRange: radius));

    if (selectedRadius != null) {
      setState(() {
        radius = selectedRadius;
      });
    }
  }

  Future<void> _showCategoryDialog() async {
    final ItemCategory? selectedCategory = await showDialog<ItemCategory>(
        context: context,
        builder: (context) => CategoryPicker(initialCategory: category));

    if (selectedCategory != null) {
      setState(() {
        category = selectedCategory;
      });
    }
  }

  Future<void> _showAllergyDialog() async {
    final List<ItemAllergy>? selectedAllergies =
        await showDialog<List<ItemAllergy>>(
            context: context,
            builder: (context) => AllergiesPicker(initialAllergies: allergies));

    if (selectedAllergies != null) {
      setState(() {
        allergies = selectedAllergies;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    logger.d('Created Google Map');
  }

  @override
  Widget build(BuildContext context) {
    final Stream<SharedItem> sharedItemStream =
        sharedItemService.getSharedItemsWithinRadius(
            userLocation: widget.userLocation,
            radiusInKm: radius,
            userId: userId);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1.0,
            child: SizedBox(
                height: 200,
                child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.userLocation.latitude,
                          widget.userLocation.longitude),
                      zoom: 15.0 - radius / 5,
                    ))),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                ActionChip(
                  onPressed: _showCategoryDialog,
                  avatar: const Icon(Icons.tune, size: 16),
                  label: category != null
                      ? Text('Category: ${category!.name}')
                      : const Text('Category: Any'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ActionChip(
                  onPressed: _showRangeDialog,
                  avatar: const Icon(Icons.location_pin, size: 16),
                  label: Text('Range (${radius.round().toString()} km)'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ActionChip(
                    onPressed: _showAllergyDialog,
                    avatar: const Icon(Icons.warning),
                    label: Text('Allergies (${allergies.length})'))
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Results',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
          StreamBuilder(
              stream: sharedItemStream,
              builder: (BuildContext sharedItemContext,
                  AsyncSnapshot<SharedItem> sharedItemSnapshot) {
                if (sharedItemSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Expanded(
                    child: ListView.separated(
                  itemCount: 0,
                  itemBuilder: (_, index) {
                    return Placeholder();
                  },
                  separatorBuilder: (_, index) {
                    return const Divider();
                  },
                ));
              })
        ],
      ),
    );
  }
}

class RadiusPicker extends StatefulWidget {
  final double initialRange;

  const RadiusPicker({super.key, required this.initialRange});

  @override
  State<StatefulWidget> createState() => _RadiusPickerState();
}

class _RadiusPickerState extends State<RadiusPicker> {
  double _range = 0;

  @override
  void initState() {
    super.initState();
    _range = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Range in km'),
      content: IntrinsicHeight(
          child: Slider(
        value: _range,
        max: 20,
        min: 1,
        divisions: 4,
        label: _range.round().toString(),
        onChanged: (double newValue) {
          logger.d('Slided value to $newValue');
          setState(() {
            _range = newValue.roundToDouble();
          });
        },
      )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.pop(context, _range),
            child: const Text('OK'))
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Row(
        children: <Widget>[
          Chip(
            avatar: Icon(Icons.tune, size: 16),
            label: Text('Type'),
          ),
          SizedBox(
            width: 10,
          ),
          Chip(
            avatar: Icon(Icons.location_pin, size: 16),
            label: Text('Range'),
          ),
          SizedBox(
            width: 10,
          ),
          Chip(avatar: Icon(Icons.warning), label: Text('Allergies'))
        ],
      ),
    );
  }
}

class Post extends StatelessWidget {
  final SharedItem postData;

  const Post({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostPage(postData: postData)));
        },
        style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.background),
          textStyle: const MaterialStatePropertyAll(TextStyle(
            color: Colors.black,
          )),
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        ),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item name: ${postData.name}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Amount: ${postData.amount.nominal} ${postData.amount.unit}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Distance: {TODO}',
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              )),
        ));
  }
}
