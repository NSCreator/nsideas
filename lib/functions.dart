// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'commonFunctions.dart';
import 'homepage.dart';
Stream<List<CommentsConvertor>> readComments(String c0,String d0,String c1,String d1) =>
    c1.isNotEmpty && d1.isNotEmpty?FirebaseFirestore.instance
        .collection(c0)
        .doc(d0)
        .collection(c1)
        .doc(d1)
        .collection("comments")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CommentsConvertor.fromJson(doc.data()))
        .toList()):FirebaseFirestore.instance
        .collection(c0)
        .doc(d0)
        .collection("comments")
        .orderBy("id", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CommentsConvertor.fromJson(doc.data()))
        .toList());
class youtubeInfo extends StatefulWidget {
  String url;
   youtubeInfo({required this.url});

  @override
  State<youtubeInfo> createState() => _youtubeInfoState();
}

class _youtubeInfoState extends State<youtubeInfo> {

  @override
  Widget build(BuildContext context) {
    double Size=size(context);
    return Padding(
      padding:  EdgeInsets.all(Size*4.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Size*35),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Making Video",
                  style: TextStyle(
                      fontSize: Size*20,
                      color: Colors.white),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(Size*20)),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical:Size*5.0,horizontal: 15),
                        child: Text(
                          "Play",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Size*20),
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible:
                        false, // user must tap button!
                        builder: (BuildContext context) {
                          return youtube(
                            url: widget.url,
                          );
                        },
                      );
                    },
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(Size*20)),
                      child: Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical:Size*5.0,horizontal: 15),
                            child: Text(
                              "View On",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Size*20),
                            ),
                          ),
                          Container(
                              height: Size*40,
                              width: Size*100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://ghiencongnghe.info/wp-content/uploads/2021/02/bia-youtube-la-gi.gif"))))
                        ],
                      ),
                    ),
                    onTap: () {
                      ExternalLaunchUrl(widget.url);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    ;
  }
}



class CommentsConvertor {
  String id;
  final String data;
  List<String> likedBy,reply;

  CommentsConvertor(
      {this.id = "",
        required this.data,
        List<String>? likedBy,
        List<String>? reply,

      }) : likedBy = likedBy ?? [],reply = reply ?? [];

  Map<String, dynamic> toJson() => {
    "id": id,
    "data": data,

  };

  static CommentsConvertor fromJson(Map<String, dynamic> json) =>
      CommentsConvertor(
          id: json['id'],
          data: json["data"],
        likedBy:
        json["likedBy"] != null ? List<String>.from(json["likedBy"]) : [],
        reply:json["reply"] != null ? List<String>.from(json["reply"]) : [],
          );
}

Future<void> InternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView)) {
    throw 'Could not launch $urlIn';
  }
}

SendingMails(String urlIn) async {
  var url = Uri.parse("mailto:$urlIn");
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

Future<void> ExternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urlIn';
  }
}


userId() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[0];
}

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}

isUser() {
  return FirebaseAuth.instance.currentUser!.email! == "sujithnimmala03@gmail.com";
}


Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    fontSize: 18,
    timeInSecForIosWeb: 5
  );
}


class scrollingImages extends StatefulWidget {
  final List images;
  final String id;
  bool isZoom;

   scrollingImages({Key? key, required this.images,required this.id,this.isZoom=false}) : super(key: key);

  @override
  State<scrollingImages> createState() => _scrollingImagesState();
}

class _scrollingImagesState extends State<scrollingImages> {
  String imagesDirPath='';
  int currentPos = 0;


  @override
  Widget build(BuildContext context) {
    double Size=size(context);
    return Column(
      children: [
        CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: widget.images.length > 1?true:false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
            itemBuilder: (BuildContext context, int itemIndex,
                int pageViewIndex) {

              return ClipRRect(
                  borderRadius: BorderRadius.circular(Size*10),
                  child: ImageShowAndDownload(
              image: widget.images[itemIndex],
              id: widget.id,
                    isZoom: widget.isZoom,
              ));
            }),
        if(widget.images.length > 1)Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.map((url) {
            int index = widget.images.indexOf(url);
            return Container(
              width: 5.0,
              height: 5.0,
              margin: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPos == index
                    ? Colors.white
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
