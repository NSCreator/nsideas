// ignore_for_file: non_constant_identifier_names, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/homepage.dart';

import 'authPage.dart';
import 'functions.dart';
import 'textField.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:math';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:ns_ideas/authPage.dart';
import 'electronicProjects.dart';
import 'raspberrypi.dart';
import 'searchBar.dart';
import 'sensors.dart';
import 'arduino.dart';
import 'commonFunctions.dart';
import 'functions.dart';
import 'settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String ownerId = "sujithnimmala03@gmail.com";
String noImageUrl = "No Photo Url Available";
String longPressToViewImage = "Long Press To View Image";

const TextStyle HeadingsTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String apiKey = 'AIzaSyCiHAuZJyIZoMmdDIldB1UlLn8OBsOE2E0';
  String channelId = 'UCcFrrU5HatzM6JNuQAjw-Ew';
  getVideoStatistics(String videoUrl) async {
    if(videoUrl.isNotEmpty){
      final yt = YoutubeExplode();
      final video = await yt.videos.get(videoUrl);
      yt.close();
      return '${video.engagement.viewCount},${video.engagement.likeCount};${video.uploadDate}';
    }
    else{
      return '0,0;0';

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(
                text: "Settings",
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Arduino Projects",
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final response = await http.get(
                            Uri.parse(
                                'https://www.googleapis.com/youtube/v3/playlistItems?'
                                'key=$apiKey&playlistId=PLA3HY7QO-s-4S-1c0JPkQ-TCLudv0VGjg&part=snippet&maxResults=10'),
                          );

                          if (response.statusCode == 200) {
                            final Map<String, dynamic> data =
                                json.decode(response.body);
                            List<dynamic> videoList = data['items'];
                            final yt = YoutubeExplode();
                            for(final video in videoList){
                              showToastText("${video['snippet']['resourceId']["videoId"]}");
                                final videoPublishTime =
                                    video['snippet']['publishedAt'];
                                final videoThumbnails = video['snippet']
                                        ['thumbnails']['medium']['url'] +
                                    "," +
                                    video['snippet']['thumbnails']['standard']
                                        ['url'] +
                                    "," +
                                    video['snippet']['thumbnails']['maxres']
                                        ['url'];
                             String VL= await getVideoStatistics(video['snippet']['resourceId']["videoId"]);
                              FirebaseFirestore.instance
                                    .collection('projectsInfo')
                                    .doc("arduinoProjectsInfo")
                                    .collection("arduinoProjectsInfo")
                                    .doc(video['snippet']['resourceId']["videoId"])
                                    .set({
                                  "id": video['snippet']['resourceId']["videoId"],
                                  "title": video['snippet']['title'],
                                  "time": VL.split(";").last,
                                  "Thumbnails": videoThumbnails,
                                  "ViewsLikes": VL.split(";").first
                                });
                            }
                            // for (final video in videoList) {
                            //   final videoLV = await yt.videos.get(video["id"]);
                            //
                            //   final videoId = video['id'];
                            //   // final videoTitle = video['snippet']['title'];
                            //   // // // final videoDescription = video['snippet']['description'];
                            //   // final videoPublishTime =
                            //   //     video['snippet']['publishedAt'];
                            //   // final videoThumbnails = video['snippet']
                            //   //         ['thumbnails']['medium']['url'] +
                            //   //     "," +
                            //   //     video['snippet']['thumbnails']['standard']
                            //   //         ['url'] +
                            //   //     "," +
                            //   //     video['snippet']['thumbnails']['maxres']
                            //   //         ['url'];
                            //   // String VL = "${videoLV.engagement.viewCount}" +
                            //   //     "," +
                            //   //     "${videoLV.engagement.likeCount}";
                            //   await FirebaseFirestore.instance
                            //       .collection('arduino')
                            //       .doc("arduinoProjectsInfo")
                            //       .collection("arduinoProjectsInfo")
                            //       .doc(videoId)
                            //       .set({
                            //     "id": videoId,
                            //     // "title": videoTitle,
                            //     // "time": videoPublishTime,
                            //     // "Thumbnails": videoThumbnails,
                            //     // "ViewsLikes": VL
                            //   });
                            //
                            //   yt.close();
                            // }
                          } else {
                            throw Exception('Failed to load videos');
                          }
                        },
                        child: Text("Update"))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Electronic Projects",
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final response = await http.get(
                            Uri.parse(
                                'https://www.googleapis.com/youtube/v3/playlistItems?key=AIzaSyCiHAuZJyIZoMmdDIldB1UlLn8OBsOE2E0&playlistId=PLA3HY7QO-s-5GFcHRs403_E-cNCF4oK23&part=snippet&maxResults=100'),
                          );

                          if (response.statusCode == 200) {
                            final Map<String, dynamic> data =
                                json.decode(response.body);
                            List<dynamic> videoList = data['items'];


                            for(int x = 0; x < videoList.length; x++){
                              final video =videoList[x];
                              showToastText("${videoList.length}");
final images =video['snippet']
['thumbnails'];
                                String videoThumbnails = images['medium']['url']??"" +
                                    "," +
                                    images['standard']
                                        ['url']??"" +
                                    "," +
                                    images['maxres']
                                        ['url']??"";
                             String VL= await getVideoStatistics(video['snippet']['resourceId']["videoId"]);
                              FirebaseFirestore.instance
                                    .collection('projectsInfo')
                                    .doc("electronicProjectsInfo")
                                    .collection("electronicProjectsInfo")
                                    .doc(video['snippet']['resourceId']["videoId"])
                                    .set({
                                  "id": video['snippet']['resourceId']["videoId"],
                                  "title": video['snippet']['title']??"",
                                  "time": VL.split(";").last,
                                  "Thumbnails": videoThumbnails,
                                  "ViewsLikes": VL.split(";").first
                                });
                            }

                          } else {
                            throw Exception('Failed to load videos');
                          }
                        },
                        child: Text("Update"))
                  ],
                ),
              ),
              if (isUser())
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Editing Options:",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              width: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.all(11.0),
                                child: Text(
                                  "Add Arduino Board",
                                  style: TextStyle(
                                      fontSize: 23, color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          arduinoBoardCreator()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              width: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.all(11.0),
                                child: Text(
                                  "Add Arduino Project",
                                  style: TextStyle(
                                      fontSize: 23, color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          arduinoProjectCreator()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              width: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.all(11.0),
                                child: Text(
                                  "Add Raspberry Pi Board",
                                  style: TextStyle(
                                      fontSize: 23, color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => createNewOne()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              width: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.all(11.0),
                                child: Text(
                                  "Add Electronic Project",
                                  style: TextStyle(
                                      fontSize: 23, color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          electronicProjectsCreator()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              StreamBuilder<List<followUsConvertor>>(
                  stream: readfollowUs(),
                  builder: (context, snapshot) {
                    final Books = snapshot.data;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0.3,
                          color: Colors.cyan,
                        ));
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                                  'Error with TextBooks Data or\n Check Internet Connection'));
                        } else {
                          if (Books!.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "No Treading Projects",
                                  style: TextStyle(
                                    color: Color.fromRGBO(195, 228, 250, 1),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 20, bottom: 8),
                                  child: Text(
                                    "Follow Us",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(195, 228, 250, 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Books.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  174, 228, 242, 0.15),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            // border: Border.all(color: Colors.white),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      Books[index].photoUrl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                height: 35,
                                                width: 50,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  Books[index].name,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 9,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                    }
                  }),
              Center(
                child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 13, right: 13, top: 8, bottom: 8),
                          child: Text(
                            "Log Out",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.black.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 16,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  const SizedBox(height: 5),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Do you want Log Out",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                "Back",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                "Log Out",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()));
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Stream<List<followUsConvertor>> readfollowUs() => FirebaseFirestore.instance
    .collection('FollowUs')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => followUsConvertor.fromJson(doc.data()))
        .toList());

class followUsConvertor {
  String id;
  final String name, link, photoUrl;

  followUsConvertor(
      {this.id = "",
      required this.name,
      required this.link,
      required this.photoUrl});

  static followUsConvertor fromJson(Map<String, dynamic> json) =>
      followUsConvertor(
          id: json['id'],
          name: json["name"],
          link: json["link"],
          photoUrl: json["photoUrl"]);
}
