// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/raspberrypi.dart';
import 'package:ns_ideas/sensors.dart';
import 'package:ns_ideas/textField.dart';
import 'package:photo_view/photo_view.dart';
import 'arduino.dart';
import 'electronicProjects.dart';
import 'searchBar.dart';
import 'functions.dart';
import 'settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class imageHeadingTagsDescription extends StatefulWidget {
  String photoUrl, id, heading, description;
  List tags;

  imageHeadingTagsDescription(
      {super.key,
      required this.heading,
      required this.id,
      required this.description,
      required this.photoUrl,
      required this.tags});

  @override
  State<imageHeadingTagsDescription> createState() =>
      _imageHeadingTagsDescriptionState();
}

class _imageHeadingTagsDescriptionState
    extends State<imageHeadingTagsDescription> {
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Padding(
      padding: EdgeInsets.all(Size * 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.photoUrl.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(Size * 5.0),
              child: scrollingImages(
                images: widget.photoUrl.split(";"),
                id: widget.id,
                isZoom: true,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(Size * 5.0),
            child: Text(
              widget.heading.split(";").last,
              style: TextStyle(fontSize: Size * 20, color: Colors.white),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: widget.tags
                .map(
                  (text) => Padding(
                    padding: EdgeInsets.only(left: Size * 5, bottom: Size * 5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Size * 10),
                          border: Border.all(color: Colors.white24)),
                      padding: EdgeInsets.symmetric(
                          vertical: Size * 3, horizontal: Size * 8),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Container(
            height: Size * 1,
            width: double.infinity,
            color: Colors.white24,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Size * 8,
                    right: Size * 8,
                    top: Size * 10,
                    bottom: Size * 3),
                child: Text(
                  "About",
                  style: TextStyle(fontSize: Size * 25, color: Colors.white),
                ),
              ),
              Container(
                height: Size * 2,
                width: Size * 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Size * 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Size * 10,
                    right: Size * 10,
                    bottom: Size * 15,
                    top: Size * 13),
                child: Text(
                  "     ${widget.description}",
                  style: TextStyle(fontSize: Size * 16, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class backGroundImage extends StatefulWidget {
  Widget child;
  String text;

  backGroundImage({super.key, required this.child, this.text = ""});

  @override
  State<backGroundImage> createState() => _backGroundImageState();
}

class _backGroundImageState extends State<backGroundImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: widget.child,
            )),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SafeArea(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 30, left: 8, right: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(1),
                        Colors.black.withOpacity(1),
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.01)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 25,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            " ${widget.text}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ))),
          ],
        ),
      ),
    );
  }
}

class VideoList extends StatefulWidget {
  final List<ProjectsConvertor> data;

  const VideoList({super.key, required this.data});

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    final sortByViews = widget.data;

    sortByViews.sort((a, b) => int.parse(b.VL.split(";").first)
        .compareTo(int.parse(a.VL.split(";").first)));
    final top2Views = sortByViews.take(2).toList();

    final sortByLikes = widget.data;

    sortByLikes.sort((a, b) => int.parse(b.VL.split(";").last)
        .compareTo(int.parse(a.VL.split(";").last)));
    final top2Likes = sortByLikes.take(2).toList();
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Most Viewed Video",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: top2Views.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final subjectsData = top2Views[index];
                return videoInfo(
                  data: subjectsData,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Most Liked Video",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final subjectsData = sortByLikes[index];
                return videoInfo(
                  data: subjectsData,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "All Video",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.data.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final subjectsData = widget.data[index];
                return videoInfo(
                  data: subjectsData,
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

class videoInfo extends StatefulWidget {
  ProjectsConvertor data;

  videoInfo({super.key, required this.data});

  @override
  State<videoInfo> createState() => _videoInfoState();
}

class _videoInfoState extends State<videoInfo> {
  @override
  Widget build(BuildContext context) {
    DateTime targetDate = DateFormat("dd-MM-yyyy").parse(
        DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.data.time)));
    String daysDifference = calculateDifferenceText(targetDate);
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                        aspectRatio: 15 / 9,
                        child: ImageShowAndDownload(
                          image: widget.data.images.trim(),
                          id: widget.data.id,
                        )))),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.heading,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.data.VL.replaceAll(";", " Views ")} Likes ",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          Text(
                            daysDifference,
                            style:
                                TextStyle(fontSize: 10, color: Colors.white70),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
      onTap: () async {
        if (widget.data.type.split(";").last == "AP") {
          FirebaseFirestore.instance
              .collection("arduino")
              .doc("arduinoProjects")
              .collection("projects")
              .doc(widget.data.type.split(";").first.trim())
              .get()
              .then((DocumentSnapshot snapshot) async {
            if (snapshot.exists) {
              var data = snapshot.data();
              if (data != null && data is Map<String, dynamic>) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => arduinoProject(
                              appsAndPlatforms: data["appsAndPlatforms"],
                              youtubeUrl: widget.data.id,
                              id: data['id'],
                              heading: data['heading'],
                              description: data['description'],
                              photoUrl: widget.data.images.split(",").first,
                              tags: data['tags'].toString().split(";"),
                              tableOfContent: data['tableOfContent'],
                              views: 0,
                              componentsAndSupplies:
                                  data['componentsAndSupplies'],
                              comments: data["comments"],
                            )));
              }
            } else {
              print("Document does not exist.");
            }
          }).catchError((error) {
            print("An error occurred while retrieving data: $error");
          });
        } else if (widget.data.type.split(";").last == "EP") {
          List<String> images = [];
          images = widget.data.images.split(",");


          FirebaseFirestore.instance
              .collection("electronicProjects")
              .doc(widget.data.type.split(";").first)
              .get()
              .then((DocumentSnapshot snapshot) async {
            if (snapshot.exists) {
              var data = snapshot.data();
              if (data != null && data is Map<String, dynamic>) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        electronicProject(
                      likes: data['likedBy'],
                      tags: data['tags'].split(";"),
                      youtubeUrl: widget.data.id,
                      views: widget.data.VL.split(",").first,
                      requiredComponents: data['requiredComponents'],
                      toolsRequired: data['toolsRequired'],
                      id: data['id'],
                      heading: data['heading'],
                      description: data['description'],
                      photoUrl: widget.data.images,
                      tableOfContent: data['tableOfContent'],
                      comments: data["comments"],
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final fadeTransition = FadeTransition(
                        opacity: animation,
                        child: child,
                      );

                      return Container(
                        color: Colors.black.withOpacity(animation.value),
                        child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: animation.value.clamp(0.3, 1.0),
                            child: fadeTransition),
                      );
                    },
                  ),
                );
              }
            } else {
              print("Document does not exist.");
            }
          }).catchError((error) {
            print("An error occurred while retrieving data: $error");
          });
        } else {
          showToastText("document does not exist.");
        }
      },
    );
  }
}

String calculateDifferenceText(DateTime targetDate) {
  DateTime currentDate = DateTime.now();
  Duration difference = currentDate.difference(targetDate);

  if (difference.inDays >= 365) {
    int years = (difference.inDays / 365).floor();
    return '$years years ago';
  } else if (difference.inDays >= 30) {
    int months = (difference.inDays / 30).floor();
    return '$months months ago';
  } else {
    return '${difference.inDays} days ago';
  }
}

class HomePage extends StatefulWidget {
  final List<ProjectsConvertor> data;

  const HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List searchList = ["Search About", "Arduino", "Raspberry Pi", "Sensors"];
  List tabBatList = [
    "Arduino & ESP;https://i.ytimg.com/vi/9RZr3W6aDE8/mqdefault.jpg",
    "Raspberry Pi;https://i.ytimg.com/vi/9RZr3W6aDE8/mqdefault.jpg",
    "Electronics;https://i.ytimg.com/vi/9RZr3W6aDE8/mqdefault.jpg",
    "Sensors;https://i.ytimg.com/vi/9RZr3W6aDE8/mqdefault.jpg",
  ];
  // late final RewardedAd rewardedAd;
  // bool isAdLoaded = false;
  //
  // void _loadRewardedAd() {
  //   RewardedAd.load(
  //     adUnitId: AdVideo.bannerAdUnitId,
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdFailedToLoad: (LoadAdError error) {
  //         print("Failed to load rewarded ad, Error: $error");
  //       },
  //       onAdLoaded: (RewardedAd ad) async {
  //         print("$ad loaded");
  //         showToastText("Add loaded");
  //         rewardedAd = ad;
  //         _setFullScreenContentCallback();
  //         await _showRewardedAd();
  //         final user = _auth.currentUser;
  //         if (user != null) {
  //           final imageRef = _firestore
  //               .collection('user')
  //               .doc(fullUserId());
  //           await imageRef.update({
  //             'lastOpenAdTime':
  //             FieldValue.serverTimestamp(),
  //           });
  //         }
  //
  //
  //
  //
  //       },
  //     ),
  //   );
  // }
  //
  // //method to set show content call back
  // void _setFullScreenContentCallback() {
  //   if (rewardedAd == null) {
  //     return;
  //   }
  //   rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
  //     //when ad  shows fullscreen
  //     onAdShowedFullScreenContent: (RewardedAd ad) =>
  //         print("$ad onAdShowedFullScreenContent"),
  //     //when ad dismissed by user
  //     onAdDismissedFullScreenContent: (RewardedAd ad) {
  //       print("$ad onAdDismissedFullScreenContent");
  //
  //       //dispose the dismissed ad
  //       ad.dispose();
  //     },
  //     //when ad fails to show
  //     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
  //       print("$ad  onAdFailedToShowFullScreenContent: $error ");
  //       //dispose the failed ad
  //       ad.dispose();
  //     },
  //
  //     //when impression is detected
  //     onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
  //   );
  // }
  //
  // Future<void> _showRewardedAd() async {
  //   rewardedAd.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  //         num amount = rewardItem.amount;
  //         showToastText("You earned: $amount");
  //
  //       });
  //   final imageRef = _firestore.collection("user").doc(fullUserId());
  //
  //   final documentSnapshot = await imageRef.get();
  //   if (documentSnapshot.exists) {
  //     final data = documentSnapshot.data() as Map<String, dynamic>;
  //     if (data['adSeenCount']==null) {
  //       _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":0});
  //     } else {
  //       _firestore.collection("user").doc(fullUserId()).update({"adSeenCount":data['adSeenCount']+1});
  //
  //     }
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double remainingTime = 0;

  //
  //
  // Future<void> _checkImageOpenStatus() async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     final imageRef = _firestore.collection("user").doc(fullUserId());
  //     final documentSnapshot = await imageRef.get();
  //     if (documentSnapshot.exists) {
  //       final data = documentSnapshot.data() as Map<String, dynamic>;
  //       if (data['lastOpenAdTime']==null) {
  //         _loadRewardedAd();
  //       } else {
  //         final lastOpenTime = data['lastOpenAdTime'] as Timestamp;
  //         final currentTime = Timestamp.now();
  //         final difference = currentTime.seconds - lastOpenTime.seconds;
  //         if(difference >= 3600){
  //           _loadRewardedAd();
  //         }else{
  //           remainingTime = (3600 - difference) / 60;
  //           showToastText("$remainingTime");
  //         }
  //       }
  //     }
  //   }
  // }
  @override
  void initState()  {
    super.initState();
    // _checkImageOpenStatus();
  }
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<List<HomePageImagesConvertor>>(
                    stream: readHomePageImagesConvertor(),
                    builder: (context, snapshot) {
                      final subjects = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 0.3,
                              color: Colors.cyan,
                            ),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Text("Error with server");
                          } else {
                            return HomePageMenuBar(
                              data: subjects!.toList(),
                            );
                          }
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Projects & Other",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tabBatList.length,
                        itemBuilder: (context, index) {
                          List a = [
                            "assets/uno.png",
                            "assets/raspi.png",
                            "assets/electronics.png",
                            "assets/sensors.png"
                          ];
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 20 : 8,
                                right: index == tabBatList.length - 1 ? 20 : 0),
                            child: InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                        height: 60,
                                        width: 90,
                                        color: Colors.white54,
                                        child: Image.asset(a[index])),
                                  ),
                                  Text(
                                    tabBatList[index].split(";").first,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )
                                ],
                              ),
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              arduinoAndProjects(
                                                data: widget.data,
                                              )));
                                } else if (index == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              raspberrypiBoards()));
                                } else if (index == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              electronicProjectsInfo(
                                                data: widget.data,
                                              )));
                                } else if (index == 3) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              sensorsAndComponents()));
                                }
                              },
                            ),
                          );
                        }),
                  ),
                  VideoList(
                    data: widget.data,
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SafeArea(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 30, left: 8, right: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(1),
                        Colors.black.withOpacity(1),
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.01)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const settings(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final fadeTransition = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color:
                                      Colors.black.withOpacity(animation.value),
                                  child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: animation.value.clamp(0.3, 1.0),
                                      child: fadeTransition),
                                );
                              },
                            ),
                          );
                        },
                        child: Icon(
                          Icons.menu_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const searchBar(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final fadeTransition = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color:
                                      Colors.black.withOpacity(animation.value),
                                  child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: animation.value.clamp(0.3, 1.0),
                                      child: fadeTransition),
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Size * 10),
                          child: Container(
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(Size * 20),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Size * 5),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: Size * 25,
                                  ),
                                  SizedBox(width: Size * 3),
                                  Flexible(
                                    child: CarouselSlider(
                                      items: List.generate(
                                        searchList.length,
                                        (int index) {
                                          return Center(
                                            child: Text(
                                              searchList[index],
                                              style: TextStyle(
                                                fontSize: Size * 15.0,
                                                color: Color.fromRGBO(
                                                    192, 237, 252, 1),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      //Slider Container properties
                                      options: CarouselOptions(
                                        scrollDirection: Axis.vertical,
                                        // Set the axis to vertical
                                        viewportFraction: 0.95,
                                        disableCenter: true,
                                        enlargeCenterPage: true,
                                        height: Size * 40,
                                        autoPlayAnimationDuration:
                                            const Duration(seconds: 3),
                                        autoPlay: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
          ],
        ),
      ),
    );
  }
}

class HomePageMenuBar extends StatefulWidget {
  final List<HomePageImagesConvertor> data;

  const HomePageMenuBar({super.key, required this.data});

  @override
  _HomePageMenuBarState createState() => _HomePageMenuBarState();
}

class _HomePageMenuBarState extends State<HomePageMenuBar> {
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: widget.data.map((item) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                onPageChanged: (index, reason) {
                  setState(() {
                    imageIndex = index;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.01),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.data.asMap().entries.map((entry) {
                    int index = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 1),
                      child: Container(
                        height: 6,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: imageIndex == index
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class electronicProjectsInfo extends StatefulWidget {
  final List<ProjectsConvertor> data;

  electronicProjectsInfo({required this.data});

  @override
  State<electronicProjectsInfo> createState() => _electronicProjectsInfoState();
}

class _electronicProjectsInfoState extends State<electronicProjectsInfo> {
  late List filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = widget.data
        .where((subjectData) => subjectData.type.split(";").last == "EP")
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return backGroundImage(
      text: "Electronic Projects",
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredData.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final SubjectsData = filteredData[index];
              return InkWell(
                  child: videoInfo(
                    data: SubjectsData,
                  ),
                  onTap: () async {
                    List<String> images = [];
                    images = SubjectsData.images.split(",");


                    FirebaseFirestore.instance
                        .collection("electronicProjects")
                        .doc("0CjLuNtpMqYvLP5mYjCp")
                        .get()
                        .then((DocumentSnapshot snapshot) async {
                      if (snapshot.exists) {
                        var data = snapshot.data();
                        if (data != null && data is Map<String, dynamic>) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      electronicProject(
                                likes: data['likedBy'],
                                tags: data['tags'].split(";"),
                                youtubeUrl: SubjectsData.id,
                                views: SubjectsData.VL.split(",").first,
                                requiredComponents: data['requiredComponents'],
                                toolsRequired: data['toolsRequired'],
                                id: data['id'],
                                heading: SubjectsData.heading,
                                description: data['description'],
                                photoUrl: SubjectsData.images.toString().replaceAll(',', ";"),
                                tableOfContent: data['tableOfContent'],
                                comments: data["comments"],
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final fadeTransition = FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );

                                return Container(
                                  color:
                                      Colors.black.withOpacity(animation.value),
                                  child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: animation.value.clamp(0.3, 1.0),
                                      child: fadeTransition),
                                );
                              },
                            ),
                          );
                        }
                      } else {
                        print("Document does not exist.");
                      }
                    }).catchError((error) {
                      print("An error occurred while retrieving data: $error");
                    });
                  });
            },
          )
        ],
      ),
    );
  }
}

class ImageShowAndDownload extends StatefulWidget {
  String id, image;
  bool isZoom;

  ImageShowAndDownload(
      {super.key, required this.image, required this.id, this.isZoom = false});

  @override
  State<ImageShowAndDownload> createState() => _ImageShowAndDownloadState();
}

class _ImageShowAndDownloadState extends State<ImageShowAndDownload> {
  String filePath = "";



  @override
  void initState() {
    super.initState();
    getPath();
  }

  getPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    filePath = '${appDir.path}/${widget.id}/${Uri.parse(widget.image).pathSegments.last}';
    if (!File(filePath).existsSync()) {
      await _downloadImages(widget.image);
    }
    setState(() {
      filePath;
    });
  }

  _downloadImages(String url) async {
    String name;
    final Uri uri = Uri.parse(url);
    if (url.startsWith('https://drive.google.com')) {
      name = url.split(";").first.split('/d/')[1].split('/')[0];
      url = "https://drive.google.com/uc?export=download&id=$name";
    }
    else {
      name = uri.pathSegments.last.split("/").last;
    }
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final newDirectory = Directory('${documentDirectory.path}/${widget.id}');
    if (!await newDirectory.exists()) {
      await newDirectory.create(recursive: true);
    }
    final file = File('${newDirectory.path}/$name');
    await file.writeAsBytes(response.bodyBytes);

  }

  @override
  Widget build(BuildContext context) {
    return
      widget.isZoom
        ? InkWell(
            child: !File(filePath).existsSync()
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    )),
                    )
                : Image.file(
              File(filePath),
                    fit: BoxFit.cover,
                  ),
            onTap: () {
              if (widget.isZoom)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                            backgroundColor: Colors.black,
                            body: SafeArea(
                              child: Column(
                                children: [
                                  backButton(text: "back",),
                                  Expanded(
                                    child: Center(
                                      child: File(filePath).existsSync()
                                          ? PhotoView(
                                              imageProvider: FileImage(File(filePath)))
                                          : PhotoView(
                                              imageProvider:
                                                  NetworkImage(widget.image),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ))));
            },
          )
        :
    !File(filePath).existsSync()
            ?
    Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.cover,
                )),
                )
            :
    Image.file(
      File(filePath),
                fit: BoxFit.cover,
              )
    ;
  }
}
