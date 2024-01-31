import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adopt/data/pet_data.dart';
import 'package:pet_adopt/preference/shared_preference.dart';
import 'package:pet_adopt/screen/pic_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/home_bloc.dart';
import '../constants/constants.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final bool isAdopted;
  final VoidCallback onDataUpdated;
  final bool isDarkMode;

  const DetailScreen(
      {Key? key,
      required this.data,
      required this.index,
      required this.isAdopted,
      required this.onDataUpdated,
      required this.isDarkMode})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isAdopted = false;
  late ConfettiController _centerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAdopted = widget.isAdopted;
    _centerController =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        topView(context),
        confetiWidget(),
        bottomView(context, widget.isDarkMode),
      ],
    ));
  }

  topView(BuildContext context) => Stack(children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PicView(imageUrl: widget.data["image"])),
            );
          },
          child: Hero(
            tag: 'hero_${widget.index}',
            child: Container(
              height: MediaQuery.of(context).size.height * 0.63,
              child: CachedNetworkImage(
                  height: 150,
                  imageUrl: widget.data["image"],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.appTextColor),
                            strokeWidth: 2.0,
                          ))),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error))),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: Constants.getStatusBarHeight(context) + 12, left: 20),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
      ]);

  bottomView(BuildContext context, bool isDark) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Text(widget.data["name"],
                        style: TextStyle(
                            color: isDark
                                ? Colors.white.withOpacity(0.9)
                                : Constants.appTextColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto")),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        priceAgeContainer(
                            Color(0xff6737C9), widget.data["price"]),
                        SizedBox(
                          width: 10,
                        ),
                        priceAgeContainer(Colors.green, widget.data["age"]),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    adoptMeButton(context, widget.data["id"].toString(),
                        widget.data["name"])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  priceAgeContainer(Color color, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.2)),
      // padding: const EdgeInsets.only(left: 8, top: 2),
      child: Text(
        text,
        style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto"),
      ),
    );
  }

  adoptMeButton(BuildContext context, String id, String petName) {
    return GestureDetector(
      onTap: () async {
        if (!isAdopted) {
          setPetAdopted(id);
          setState(() {
            isAdopted = true;
          });
          widget.onDataUpdated();
          _centerController.play();
          showDialogue(petName);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isAdopted
                ? Color(0xff6737C9).withOpacity(0.5)
                : Color(0xff6737C9).withOpacity(0.85)),
        child: Center(
          child: Text(
            isAdopted ? Constants.alreadyAdopted : Constants.adoptMe,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: "Roboto"),
          ),
        ),
      ),
    );
  }

  void setPetAdopted(String id) async {
    List<String> petData = [];
    bool isExists = await checkIfKeyExists("adoptedPetData");
    if (isExists) {
      petData = await getPrefList("adoptedPetData");
      if (!petData.contains(id)) {
        setPrefList("adoptedPetData", addPetDataDb(id, petData));
      }
    } else {
      setPrefList("adoptedPetData", addPetDataDb(id, petData));
    }
  }

  addPetDataDb(String id, List<String> petData) {
    List<String> idList = petData;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    idList.add("$id-$timestamp");
    idList.sort((a, b) {
      int timestampA = int.parse(a.split('-')[1]);
      int timestampB = int.parse(b.split('-')[1]);
      return timestampB.compareTo(timestampA);
    });
    return idList;
  }

  confetiWidget() {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _centerController,
        blastDirection: pi / 2,
        maxBlastForce: 4,
        minBlastForce: 1,
        emissionFrequency: 0.03,
        numberOfParticles: 10,
        gravity: 0,
      ),
    );
  }

  void showDialogue(dynamic petName) {
    var pet = petName;
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: RichText(
              text: TextSpan(
                text: Constants.adoptionSuccessText + "\n",
                style: TextStyle(
                    color: Constants.appTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
                children: [
                  WidgetSpan(
                    child: Text(
                      petName,
                      style: TextStyle(
                        color: Constants.appTextColor,
                        fontFamily: "Roboto",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
