import 'package:flutter/material.dart';
import 'package:location/location.dart';

// The social places timeline
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    const postData = [
      PostData(
          title: 'Red bell pepper',
          distance: 0.2,
          measurement: 'items',
          amount: 2),
      PostData(
          title: 'Green bell pepper',
          distance: 0.3,
          measurement: 'items',
          amount: 1),
      PostData(
          title: 'Grated gouda cheese',
          distance: 0.5,
          measurement: 'grams',
          amount: 200),
      PostData(
          title: 'Green bell pepper',
          distance: 0.6,
          measurement: 'items',
          amount: 1),
      PostData(
          title: 'Green bell pepper',
          distance: 1,
          measurement: 'items',
          amount: 1)
    ];
    return Column(
      children: [
      const FractionallySizedBox(
      widthFactor: 1.0,
      child: SizedBox(
              height: 200,
              child: Card(
                child: Text('Here shall be map showing locations of available items'),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        const SearchBar(),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Results',
            style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
        Expanded(child: ListView.separated(
          itemCount: postData.length,
          itemBuilder: (_, index) {
            return Post(postData: postData[index],);
          },
          separatorBuilder: (_, index) {
            return const Divider();
          },
        ))
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
          SizedBox(width: 10,),
          Chip(
            avatar: Icon(Icons.location_pin, size: 16),
            label: Text('Range'),
          ),
          SizedBox(width: 10,),
          Chip(
              avatar: Icon(Icons.warning),
              label: Text('Allergies')
          )
        ],
      ),
    );
  }
}

class PostData {
  final String title;
  final double distance;
  final String measurement;
  final double amount;

  const PostData({
    required this.title,
    required this.distance,
    required this.measurement,
    required this.amount
  });
}

class Post extends StatelessWidget {
  final PostData postData;

  const Post({
    super.key,
    required this.postData
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(postData: postData))); },
      style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.background),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              color: Colors.black,
            )
          ),
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
      ),
      child: FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item name: ${postData.title}', style: const TextStyle(color: Colors.black),),
            Text('Amount: ${postData.amount} ${postData.measurement}', style: const TextStyle(color: Colors.black),),
            Text('Distance: ${postData.distance} km', style: const TextStyle(color: Colors.black),)
          ],
        )
      ),
      )
    );
  }
}

class PostPage extends StatelessWidget {
  final PostData postData;
  
  const PostPage({
    super.key,
    required this.postData
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Shared Item Information'),
          actions: [],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FractionallySizedBox(
              widthFactor: 1.0,
              child: SizedBox(
                height: 200,
                child: Card(
                  child: Text('Here shall be map giving the range of the location of the item publisher'),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(postData.title, style: Theme.of(context).textTheme.headlineLarge,),
            Text('Amount: ${postData.amount} ${postData.measurement}', style: Theme.of(context).textTheme.headlineSmall),
          ],
        )
      )
    );
  }
}