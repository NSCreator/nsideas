// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ns_ideas/authPage.dart';
import 'package:ns_ideas/homepage.dart';
import 'package:ns_ideas/textField.dart';
import 'package:path_provider/path_provider.dart';

import 'electronicProjects.dart';

class searchBar extends StatefulWidget {
  const searchBar({Key? key}) : super(key: key);

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  String name = "";
  String folderPath="";
  File file = File("");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath();
  }
  getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    folderPath = directory.path;
  }
  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: InkWell(child: Icon(Icons.arrow_back,size: 30,color: Colors.white,),onTap: (){
                  Navigator.pop(context);
                },),
              ),
              Flexible(
                flex: 1,
                child: TextFieldContainer(
                  child: Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(right: Size*10),
                      child: Icon(
                        Icons.search,
                        size: Size*25,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: Size*16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Bar',
                          hintStyle: TextStyle(color: Colors.white54),
                            labelStyle:TextStyle(fontSize: 16)
                        ),
                      ),
                    ),
                  ],
                ),),
              ),
              if (name.isNotEmpty)
                InkWell(
                  onTap: () {
                    setState(() {
                      name = "";
                    });
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(
                      right:Size* 10,
                    ),
                    child: Icon(
                      Icons.clear,
                      size:Size* 35,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
          Expanded(
            child: StreamBuilder<List<ProjectsConvertor>>(
              stream: readProjectsConvertor(
                  "projectsInfo", "allProjectsInfo", "allProjectsInfo"),
              builder: (context, snapshot) {
                final subjects = snapshot.data;
                List<ProjectsConvertor> filteredSubjects = [];

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 0.3,
                        color: Colors.cyan,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return const Text("Error with server");
                    } else {
                      if (subjects != null) {
                        if (name.isNotEmpty) {
                          filteredSubjects = subjects.where((project) {
                            return project.heading
                                .toLowerCase()
                                .contains(name.toLowerCase());
                          }).toList();
                        } else {
                          filteredSubjects = List.from(subjects);
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),

                          itemCount: filteredSubjects.length,
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 20),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final subjectsData = filteredSubjects[index];
                            return videoInfo(data: subjectsData);
                          },
                        );
                      }
                      return Container();
                    }
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
