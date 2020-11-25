import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
//
//     final payload = payloadFromJson(jsonString);

import 'dart:convert';

List<Payload> payloadFromJson(String str) => List<Payload>.from(json.decode(str).map((x) => Payload.fromJson(x)));

String payloadToJson(List<Payload> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payload {
  String sponsorlogo;

  Payload({
    this.sponsorlogo,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    sponsorlogo: json["sponsorlogo"] == null ? null : json["sponsorlogo"],
  );

  Map<String, dynamic> toJson() => {
    "sponsorlogo": sponsorlogo == null ? null : sponsorlogo,
  };
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  Future<List<Payload>> getSponsorSlide() async {
    //final response = await http.get("getdata.php");
    //return json.decode(response.body);
    String response = '[{"sponsorlogo":"https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"},{"sponsorlogo":"https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80"},{"sponsorlogo":"https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          child: new FutureBuilder<List<Payload>>(
            future: getSponsorSlide(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new SponsorList(
                list: snapshot.data,
              )
                  : new Center(
                  child: new CircularProgressIndicator()
              );
            },
          ),
        ),
      ),
    );
  }
}

class SponsorList extends StatefulWidget {
  final List<Payload> list;
  SponsorList({this.list});

  @override
  _SponsorListState createState() => _SponsorListState();
}

class _SponsorListState extends State<SponsorList> {
  int _current = 0;

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(height: 400.0),
            items: widget.list.map((imageUrl){
              return Builder (
                  builder: (BuildContext context){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Image.network(
                        imageUrl.sponsorlogo,
                        fit:BoxFit.fill,
                      ),
                    );
                  });
            }).toList(),
          )
        ],
      ),
    );
  }
}