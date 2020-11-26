import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SponsorSlider(),
    );
  }
}

class SponsorSlider extends StatefulWidget {

  @override
  _SponsorSliderState createState() => _SponsorSliderState();
}

class _SponsorSliderState extends State<SponsorSlider> {

  List<dynamic> img = [];
  List<String> jym;

  Future<http.Response> getSponsorSlide() async {
    final response = await http.post(
        "https://demostore.mydopako.com/api/v2/frontproducts/123");
    Map<String, dynamic> map = json.decode(response.body);
    img = map["images"];

    for (Map<String, dynamic> element in img) {
      setState(() {
        jym.add('https://demostore.mydopako.com/api/upload/demostore/product/'+element['img']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getSponsorSlide();
      jym = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CarouselSlider(
          options: CarouselOptions(height: 300.0),
          items: jym.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.amber
                    ),
                    child: Image.network('$i',
                      fit: BoxFit.contain,
                    ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}