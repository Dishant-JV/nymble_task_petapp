import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_adopt/constants/constants.dart';
import 'package:pet_adopt/data/pet_data.dart';
import 'package:pet_adopt/preference/shared_preference.dart';

class HistoryScreen extends StatefulWidget {
  final bool isDark;

  const HistoryScreen({Key? key, required this.isDark}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> historyData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPetHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: Constants.getStatusBarHeight(context) + 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          widget.isDark ? Colors.white : Constants.appTextColor,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: widget.isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                Text(
                  "History",
                  style: TextStyle(
                      color:
                          widget.isDark ? Colors.white : Constants.appTextColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 2,
                      fontFamily: "Roboto"),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: historyData.length,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: Offset(1, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: widget.isDark ? Color(0xff272C3A) : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          historyData[index]["name"] ?? "",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              color:
                                  widget.isDark ? Colors.white : Colors.black,
                              fontSize: 15),
                        ),
                        Text(
                          historyData[index]["time"] ?? "",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              color:
                                  widget.isDark ? Colors.white : Colors.black,
                              fontSize: 15),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPetHistory() async {
    List<String> data = await getPrefList("adoptedPetData");
    data.forEach((element) {
      Map<String, String> mp = {};
      mp["time"] = getDateTime(int.parse(element.split('-')[1]));
      mp["name"] = getPetName(element.split('-')[0].toString());
      historyData.add(mp);
    });
    setState(() {});
  }

  getPetName(String id) {
    for (int i = 0; i < petList.length; i++) {
      if (petList[i]["id"].toString() == id) {
        return petList[i]["name"];
      }
    }
    return "";
  }

  getDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDateTime = DateFormat('dd/MM/yy H:m:s').format(dateTime);
    return formattedDateTime;
  }
}
