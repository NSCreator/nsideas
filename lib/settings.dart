// ignore_for_file: non_constant_identifier_names, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/homepage.dart';
import 'package:ns_ideas/test.dart';

import 'authPage.dart';
import 'functions.dart';
import 'textField.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// String ownerId = "sujithnimmala03@gmail.com";
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
  get(String id,String title) async {
    var videoThumbnails ="";
    String VL='';
    final yt = YoutubeExplode();
    final video = await yt.videos.get(id);
    videoThumbnails = "${video.thumbnails.maxResUrl}";
    VL="${video.engagement.viewCount};${video.engagement.likeCount}";
    final time ="${video.publishDate}" ;
    FirebaseFirestore.instance
        .collection('projectsInfo')
        .doc("allProjectsInfo")
        .collection("allProjectsInfo")
        .doc(id)
        .set({
      "id": id,
      "title": title,
      "time": time,
      "Thumbnails": videoThumbnails,
      "ViewsLikes": VL
    });
    yt.close();
  }
  @override
  Widget build(BuildContext context) {
    return backGroundImage(text: "Settings",child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if(isUser())Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Projects",
                style: TextStyle(fontSize: 20,color: Colors.white),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final response = await http.get(
                      Uri.parse('https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&part=snippet,id&order=date&maxResults=50'),
                    );
                    if (response.statusCode == 200) {
                      final Map<String, dynamic> data =
                      json.decode(response.body);
                      List<dynamic> videoList = data['items'];
                      for (int count = 0; count < videoList.length; count++) {
                        if(videoList[count]['id']['kind'] == 'youtube#video' ){
                          String id =videoList[count]['id']["videoId"];
                          showToastText(id);

                          await get(id,videoList[count]['snippet']['title']);
                        }




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

        if(isUser())Padding(
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
                                               LoginPage()));
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
    ));
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
