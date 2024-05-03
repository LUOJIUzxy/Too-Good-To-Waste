import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tooGoodToWaste/const/color_const.dart';
import 'package:tooGoodToWaste/dto/user_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tooGoodToWaste/dto/user_name_model.dart';
import 'package:tooGoodToWaste/pages/home.dart';
import 'package:tooGoodToWaste/pages/message_thread_list.dart';
import 'package:tooGoodToWaste/service/shared_items_service.dart';
import 'package:tooGoodToWaste/service/user_service.dart';

import '../dto/shared_item_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<AccountPage> {
  User? currentUser;
  TGTWUser? userData;
  Logger logger = Logger();
  Future? _future;

  UserService userService = UserService();

  Future<dynamic> asyncMethod() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      logger.e('Fetching user data but user is null');
    } else {
      TGTWUser user = await userService.getUserData(currentUser!.uid);
      setState(() {
        userData = user;
      });
      return [currentUser, userData];
    }
    // return null;
  }

  @override
  void initState() {
    _future = asyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            //throw Exception('User is null but accessing account page');
            return const Center(child: CircularProgressIndicator());
          } else {
            return AccountSettingPage(
                user: snapshot.data[0], userData: snapshot.data[1]);
          }
        });
  }
}

class AccountSettingPage extends StatefulWidget {
  final User user;
  final TGTWUser userData;

  const AccountSettingPage(
      {super.key, required this.user, required this.userData});

  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController address1Controller;
  late TextEditingController address2Controller;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;
  late TextEditingController countryController;

  late TextEditingController allergiesController;
  late TextEditingController goodPointsController;
  late TextEditingController carbonEmissionController;
  late TextEditingController ratingController;

  late UserName currentName;
  late String currentEmail;
  late String currentPhoneNumber;
  late String currentAddress1;
  late String currentAddress2;
  late String currentCity;
  late String currentZipCode;
  late String currentCountry;
  late String currentAllergies;
  late int currentGoodPoints;
  late double currentCarbonEmission;
  late double currentRating;

  @override
  void initState() {
    super.initState();

    if (widget.user.displayName == null) {
      currentName = const UserName(first: '', last: '');
    } else {
      currentName = UserName(
          first: widget.userData.name.first, last: widget.userData.name.last);
    }
    currentEmail = widget.user.email ?? '';
    currentPhoneNumber = widget.user.phoneNumber ?? '';
    currentAddress1 = widget.userData.address.line1;
    currentAddress2 = widget.userData.address.line2;
    currentCity = widget.userData.address.city;
    currentZipCode = widget.userData.address.zipCode;
    currentCountry = widget.userData.address.country;
    currentAllergies = widget.userData.allergies.join(', ');
    currentGoodPoints = widget.userData.goodPoints;
    currentCarbonEmission = widget.userData.reducedCarbonKg;
    currentRating = widget.userData.rating;

    nameController = TextEditingController(
        text: '${widget.userData.name.first} ${widget.userData.name.last}');
    emailController = TextEditingController(text: widget.user.email ?? '');
    phoneNumberController =
        TextEditingController(text: widget.userData.phoneNumber);
    address1Controller =
        TextEditingController(text: widget.userData.address.line1);
    address2Controller =
        TextEditingController(text: widget.userData.address.line2);
    cityController = TextEditingController(text: widget.userData.address.city);
    zipCodeController =
        TextEditingController(text: widget.userData.address.zipCode);
    countryController =
        TextEditingController(text: widget.userData.address.country);
    allergiesController = TextEditingController(text: currentAllergies);
    goodPointsController =
        TextEditingController(text: currentGoodPoints.toString());
    carbonEmissionController =
        TextEditingController(text: currentCarbonEmission.toString());
    ratingController = TextEditingController(text: currentRating.toString());
  }

  showUpdateDialog() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AlertDialog dialog = AlertDialog(
      title: const Text("Hey!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          )),
      content: Container(
          width: 3 * width / 5,
          height: height / 8,
          padding: const EdgeInsets.all(10.0),
          child: Text('Are you sure you want to update your information?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ))),
      actions: [
        TextButton(
          onPressed: () async {
            await updateUser();
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Yes!'),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Future<void> updateUser() async {
    final UserService userService = UserService();

    TGTWUser newUser = TGTWUser(
      name: currentName,
      rating: currentRating,
      phoneNumber: currentPhoneNumber,
      address: UserAddress(
          city: currentCity,
          country: currentCountry,
          line1: currentAddress1,
          line2: currentAddress2,
          zipCode: currentZipCode),
      allergies: currentAllergies.split(', ').toList(),
      goodPoints: currentGoodPoints,
      reducedCarbonKg: currentCarbonEmission,
    );

    await userService.updateUserData(widget.user.uid, newUser);

    //  Navigator.pop(context);
  }

  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final _media = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              toolbarHeight: 0,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.person_outline),
                    text: 'Pers. Info',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite_border_outlined),
                    text: 'Liked',
                  ),
                  Tab(
                    icon: Icon(Icons.chat_bubble_outline),
                    text: 'Messages',
                  ),
                  Tab(
                    icon: Icon(Icons.notifications_active_outlined),
                    text: 'Posted',
                  )
                ],
              ),
            ),
            body: Stack(clipBehavior: Clip.none, children: [
              Container(
                height: _media.height,
                width: _media.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(0.5, 0.0),
                    end: FractionalOffset(0.6, 0.8),
                    stops: [0.0, 0.9],
                    colors: [YELLOW, BLUE],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: TabBarView(
                  children: [
                    Stack(clipBehavior: Clip.none, children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: MediaQuery.of(context).size.height,
                        child: ListView(children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'User Information',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                            enabled: isEditMode,
                            controller: nameController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            enabled: isEditMode,
                            controller: emailController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                            ),
                            enabled: isEditMode,
                            controller: phoneNumberController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Address',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Address Line 1',
                            ),
                            enabled: isEditMode,
                            controller: address1Controller,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Address Line 2',
                            ),
                            enabled: isEditMode,
                            controller: address2Controller,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'City',
                            ),
                            enabled: isEditMode,
                            controller: cityController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Zip Code',
                            ),
                            enabled: isEditMode,
                            controller: zipCodeController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Country',
                            ),
                            enabled: isEditMode,
                            controller: countryController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Additional Information',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Allergies',
                            ),
                            enabled: isEditMode,
                            controller: allergiesController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Achievements',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Rating',
                            ),
                            enabled: isEditMode,
                            controller: ratingController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Good Points',
                            ),
                            enabled: isEditMode,
                            controller: goodPointsController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Carbon Emission',
                            ),
                            enabled: isEditMode,
                            controller: carbonEmissionController,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IntrinsicWidth(
                                  child: FilledButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                      },
                                      child: const Text('Sign Out')))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                      ),
                      Positioned(
                        top: -10.0,
                        right: 10.0,
                        child: IconButton(
                          icon: Icon(isEditMode ? Icons.done : Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEditMode = !isEditMode;
                              if (!isEditMode) {
                                // Save changes
                                currentAddress1 = address1Controller.text;
                                currentAddress2 = address2Controller.text;
                                currentName = UserName(
                                    first: nameController.text.split(' ')[0],
                                    last: nameController.text.split(' ')[1]);
                                currentEmail = emailController.text;
                                currentPhoneNumber = phoneNumberController.text;
                                currentCity = cityController.text;
                                currentZipCode = zipCodeController.text;
                                currentCountry = countryController.text;
                                currentAllergies = allergiesController.text;
                                showUpdateDialog();
                              }
                            });
                          },
                        ),
                      ),
                    ]),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: MediaQuery.of(context).size.height,
                      child: LikedPostPageWidget(),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        height: MediaQuery.of(context).size.height,
                        child: const MessageThreadList()),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: MediaQuery.of(context).size.height,
                      child: PostPageWidget(),
                    )
                  ],
                ),
              ),
            ])));
  }
}

class PostPageWidget extends StatelessWidget {
  final SharedItemService sharedItemService = SharedItemService();
  final User? user = FirebaseAuth.instance.currentUser;

  PostPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      throw Exception("Accessting post page without authentication");
    }

    final String userId = user!.uid;

    return FutureBuilder(
        future: sharedItemService.getSharedItemOfUser(userId),
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<SharedItem>> sharedItemsSnapshot) {
          if (!sharedItemsSnapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final List<SharedItem> sharedItems =
              sharedItemsSnapshot.data!.toList();

          return Expanded(
            child: ListView.builder(
                itemBuilder: (_, index) => FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        FractionallySizedBox(
                            widthFactor: 1.0,
                            child: UserSharedItemPost(
                              sharedItem: sharedItems[index],
                            ))
                      ],
                    )),
                itemCount: sharedItems.length),
          );
        });
  }
}

class UserSharedItemPost extends StatelessWidget {
  final SharedItem sharedItem;

  const UserSharedItemPost({super.key, required this.sharedItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(232, 245, 233, 1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item name: ${sharedItem.name}"),
          Text("Amount: ${sharedItem.amount.nominal} ${sharedItem.amount.unit}")
        ],
      ),
    );
  }
}

class LikedPostPageWidget extends StatelessWidget {
  final SharedItemService sharedItemService = SharedItemService();
  final User? user = FirebaseAuth.instance.currentUser;

  LikedPostPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      throw Exception("Accessting liked post page without authentication");
    }

    final String userId = user!.uid;
    List<SharedItem> sharedItems = [];

    return StreamBuilder(
        stream: sharedItemService.getLikedSharedItemOfUser(userId: userId),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> sharedItemSnapshot) {
          if (sharedItemSnapshot.connectionState == ConnectionState.active &&
              sharedItemSnapshot.hasData) {
            if (sharedItemSnapshot.data != null) {
              List<SharedItem?> results = sharedItemService
                  .createSharedItemList(sharedItemSnapshot.data!);
              for (var res in results) {
                if (res != null) {
                  logger.d('Got items: ${res.toJson()}');
                  sharedItems.add(res);
                }
              }
            }

            if (sharedItems.isEmpty) {
              return const Center(child: Text("There is no liked post yet"));
            }

            return Expanded(
                child: ListView.builder(
              itemCount: sharedItems.length,
              itemBuilder: (_, index) {
                if (sharedItems[index] != null) {
                  logger.d('Got items: ${sharedItems[index].toJson()}');
                  return Post(postData: sharedItems[index]);
                }
                return null;
              },
            ));
          } else if (sharedItemSnapshot.connectionState ==
              ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(child: Text("There is no liked item"));
          }
        });
  }
}
