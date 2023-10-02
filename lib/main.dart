import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dogImageURL = '';
  String catImageURL = '';

  static const imageSize = 500.0; // Image size
  static const middleSpacing = 10.0; // Middle spacing

  Future<void> fetchDogData() async {
    final response =
    await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        dogImageURL = data['message'];
      });
    } else {
      throw Exception('Failed to load dog data');
    }
  }

  Future<void> fetchCatData() async {
    final response =
    await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        catImageURL = data[0]['url'];
      });
    } else {
      throw Exception('Failed to load cat data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDogData();
    fetchCatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Async API Demo'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Background color
            border: Border.all(
              color: Colors.blueAccent, // Border color
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildImageWithCaption(dogImageURL),
              SizedBox(width: middleSpacing),
              _buildImageWithCaption(catImageURL),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchDogData();
          fetchCatData();
        },
        tooltip: 'Reload Images',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildImageWithCaption(String imageUrl) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          width: imageSize, // Image size
          height: imageSize,
        ),
        SizedBox(height: 10), // Add spacing between image and name
        Text(
          'Cute ${imageUrl.contains('dog') ? 'Dog' : 'Cat'}', // Default names
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}