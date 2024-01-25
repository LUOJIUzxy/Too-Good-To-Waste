import 'package:flutter/material.dart';
import 'package:tooGoodToWaste/dto/user_model.dart';
import 'package:tooGoodToWaste/dto/shared_item_model.dart';
import '../Pages/post_page.dart';

// The social places timeline
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var users = [];

    var postData = [];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          const FractionallySizedBox(
            widthFactor: 1.0,
            child: SizedBox(
              height: 200,
              child: Card(
                child: Text(
                    'Here shall be map showing locations of available items'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SearchBar(),
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
          Expanded(
              child: ListView.separated(
            itemCount: postData.length,
            itemBuilder: (_, index) {
              return Post(
                postData: postData[index],
              );
            },
            separatorBuilder: (_, index) {
              return const Divider();
            },
          ))
        ],
      ),
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
                    'Distance: ${postData.location}',
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              )),
        ));
  }
}
