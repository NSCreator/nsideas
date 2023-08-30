// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';





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
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[1] == "gmail.com";
}

// fullUserId() {
//   var user = FirebaseAuth.instance.currentUser!.email!;
//   return user;
// }

Future<void> showToastText(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    fontSize: 18,
  );
}


class scrollingImages extends StatefulWidget {
  final List images;
  final String id;
  final String typeOfProject;

  const scrollingImages({Key? key, required this.images,required this.typeOfProject,required this.id}) : super(key: key);

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
    imagesDirPath = '${appDir.path}/${widget.typeOfProject}/${widget.id}';
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
    return widget.images.length > 1
        ? Column(
      children: [
        CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                height: 260, // Adjust this value to set the desired height of the carousel
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
              return Image.file(file,fit: BoxFit.fill,);
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
        : FittedBox(
      alignment: Alignment.center,
          fit: BoxFit.fill,
          child: Image.file(file,fit: BoxFit.fill,),
        );
  }
}
