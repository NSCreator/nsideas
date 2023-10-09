// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'commonFunctions.dart';
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

downloadImagesForAllPage(BuildContext context) async {
  List<String> list = [];
  final directory = await getApplicationDocumentsDirectory();
  String folderPath = directory.path;
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("arduino")
        .doc("arduinoBoards")
        .collection("Board").get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["images"].toString().split(";").first.length > 3) {
          final Uri uri = Uri.parse(data["images"].toString().split(";").first);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = File("$folderPath/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["images"].toString().split(";").first};" + data["id"]);
          }
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
  
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("arduino")
        .doc("arduinoProjects")
        .collection("projects").get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["images"].toString().split(";").first.length > 3) {
          final Uri uri = Uri.parse(data["images"].toString().split(";").first);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["images"].toString().split(";").first};" + data["id"]);
          }
        }    if (data["images"].toString().split(";").last.length > 3) {
          final Uri uri = Uri.parse(data["images"].toString().split(";").last);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["images"].toString().split(";").last};" + data["id"]);
          }
        }

      }
    }
  } catch (e) {
    print('Error: $e');
  }

  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('raspberrypi')
        .doc("raspberrypiBoard")
        .collection("Boards").get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["photoUrl"].toString().split(";").first.length > 3) {
          final Uri uri = Uri.parse(data["photoUrl"].toString().split(";").first);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["photoUrl"].toString().split(";").first};" + data["id"]);
          }
        }


      }
    }
  } catch (e) {
    print('Error: $e');
  }

  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("electronicProjects").get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;
        if (data["images"].toString().split(";").first.length > 3) {
          final Uri uri = Uri.parse(data["images"].toString().split(";").first);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["images"].toString().split(";").first};" + data["id"]);
          }
        }    if (data["images"].toString().split(";").last.length > 3) {
          final Uri uri = Uri.parse(data["images"].toString().split(";").last);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["images"].toString().split(";").last};" + data["id"]);
          }
        }

      }
    }
  } catch (e) {
    print('Error: $e');
  }

  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("sensors").get();
    if (querySnapshot.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (final document in documents) {
        final data = document.data() as Map<String, dynamic>;

        if (data["photoUrl"].toString().split(";").first.length > 3) {
          final Uri uri = Uri.parse(data["photoUrl"].toString().split(";").first);
          final String fileName = uri.pathSegments.last;
          var name = fileName.split("/").last;
          final file = await File("${folderPath}/${data['id']}/$name");
          if (!file.existsSync()) {
            list.add("${data["photoUrl"].toString().split(";").first};" + data["id"]);
          }
        }

      }
    }
  } catch (e) {
    print('Error: $e');
  }
  print(list);
  if(list.isNotEmpty) {
    await showDialog(
    context: context,
    builder: (context) =>
        ImageDownloadsScreen(
          images: list,
        ),
  );
  }


}
Future<void> InternalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn, mode: LaunchMode.inAppWebView))
    throw 'Could not launch $urlIn';
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

  const scrollingImages({Key? key, required this.images,required this.id}) : super(key: key);

  @override
  State<scrollingImages> createState() => _scrollingImagesState();
}

class _scrollingImagesState extends State<scrollingImages> {
  String imagesDirPath='';
  int currentPos = 0;

  File file=File("");
  getPath()
  async{
    final Directory appDir = await getApplicationDocumentsDirectory();
    imagesDirPath = '${appDir.path}/${widget.id}';
    if(widget.images.length ==1){
      final Uri uri = Uri.parse(widget.images.first);
      final String filename = uri.pathSegments.last;
      file = File('$imagesDirPath/$filename');
    }
    setState(() {
      imagesDirPath;
    });
  }

@override
  void initState() {

    super.initState();
    getPath();
  }
  @override
  Widget build(BuildContext context) {
    double Size=size(context);
    return widget.images.length > 1
        ? Column(
      children: [
        CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                // height: 260, // Adjust this value to set the desired height of the carousel

                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
            itemBuilder: (BuildContext context, int itemIndex,
                int pageViewIndex) {
              final Uri uri = Uri.parse(widget.images[itemIndex]);
              final String filename = uri.pathSegments.last;
              file = File('$imagesDirPath/$filename');
              return AspectRatio(
                  aspectRatio: 16/9,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(Size*10),

                      child: Image.file(file,fit: BoxFit.fill,)));
            }),
        Row(
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
    )
        : ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Image.file(file,),
        );
  }
}
