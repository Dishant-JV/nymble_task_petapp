import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adopt/bloc/home_bloc.dart';
import 'package:pet_adopt/constants/constants.dart';
import 'package:pet_adopt/screen/detail.dart';
import 'package:pet_adopt/screen/history.dart';

import '../data/pet_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  var dummyPetList = [];

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(FetchDataEvent());
    dummyPetList = List.from(petList);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        Constants.setStatusBarColor(state.isDarkMode);
        return Container(
          color: state.isDarkMode ? Colors.black : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Constants.getStatusBarHeight(context) + 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen(
                                  isDark: state.isDarkMode,
                                )),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: state.isDarkMode
                            ? Colors.white
                            : Constants.appTextColor.withOpacity(0.1),
                      ),
                      child: Icon(Icons.history),
                    ),
                  ),
                  Switch(
                    value: state.isDarkMode,
                    onChanged: (value) {
                      context.read<HomeBloc>().toggleTheme();
                      print(state.isDarkMode);
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                Constants.homePage1,
                style: TextStyle(
                    color: state.isDarkMode
                        ? Colors.white
                        : Constants.appTextColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),
              Text(
                Constants.homePage2,
                style: TextStyle(
                    color: state.isDarkMode
                        ? Color(0xff6737C9).withOpacity(0.8)
                        : Constants.appTextColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    wordSpacing: 2,
                    fontFamily: "Roboto"),
              ),
              SizedBox(
                height: 10,
              ),
              textField(state.isDarkMode),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: dummyPetList.length,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 230),
                  itemBuilder: (BuildContext context, int index) {
                    if (state is HomeLoaded) {
                      return GestureDetector(
                          onTap: () {
                            bool isAdopted = state.itemList
                                .contains(petList[index]["id"].toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                        data: petList[index],
                                        index: index,
                                        isAdopted: isAdopted,
                                        onDataUpdated: homeBloc.fetchData,
                                        isDarkMode: state.isDarkMode,
                                      )),
                            );
                          },
                          child: Hero(
                              tag: 'hero_$index',
                              child: homeGridComponent(
                                  context,
                                  index,
                                  state.itemList,
                                  dummyPetList,
                                  state.isDarkMode)));
                    }
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  textField(bool isDark) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2), // Shadow color
          spreadRadius: 0.5, // Spread radius
          blurRadius: 3, // Blur radius
          offset: Offset(1, 3),
          // Offset in the x and y direction
        ),
      ], borderRadius: BorderRadius.circular(15)),
      child: TextField(
        onChanged: (text) {
          dummyPetList = petList
              .where((item) =>
                  item['name'].toLowerCase().contains(text.toLowerCase()))
              .toList();
          setState(() {});
        },
        style: TextStyle(
            fontSize: 14.0,
            color: isDark ? Colors.white.withOpacity(0.5) : Colors.black,
            fontFamily: "Roboto"),
        cursorHeight: 18,
        cursorColor:
            isDark ? Colors.white.withOpacity(0.3) : Constants.appTextColor,
        cursorRadius: Radius.circular(500),
        decoration: InputDecoration(
            alignLabelWithHint: false,
            labelStyle: TextStyle(
              color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey,
              fontSize: 14,
            ),
            hintStyle: TextStyle(
                fontSize: 14.0,
                color: isDark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey.withOpacity(0.8),
                wordSpacing: 3,
                fontFamily: "Roboto"),
            hintText: ' Find here..',
            contentPadding: EdgeInsets.only(left: 20),
            filled: true,
            fillColor: isDark ? Color(0xff272C3A) : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.3) : Colors.white,
                  width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: isDark ? Colors.white.withOpacity(0.3) : Colors.white,
                  width: 0),
            ),
            suffixIcon: Icon(
              Icons.search,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : Constants.appTextColor.withOpacity(0.7),
            )),
      ),
    );
  }
}

Widget homeGridComponent(BuildContext context, int index,
    List<String> idWithTimestamp, var data, bool isDark) {
  var id = [];
  idWithTimestamp.forEach((element) {
    id.add(element.split('-')[0]);
  });
  return Container(
    padding: EdgeInsets.only(bottom: 5),
    width: MediaQuery.of(context).size.width / 2,
    margin: EdgeInsets.only(bottom: 10),
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
      color: isDark ? Colors.black : Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: CachedNetworkImage(
              height: 150,
              imageUrl: data[index]["image"],
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
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 2),
          child: Text(
            data[index]["name"],
            style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.8)
                    : Constants.appTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto"),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 2),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff6737C9).withOpacity(0.2)),
              // padding: const EdgeInsets.only(left: 8, top: 2),
              child: Text(
                data[index]["price"],
                style: TextStyle(
                    color: Color(0xff6737C9),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
              ),
            ),
            Container(
              child: id.contains(data[index]["id"].toString())
                  ? Container(
                      margin: EdgeInsets.only(right: 10, top: 2),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.withOpacity(0.2)),
                      child: Text(
                        "Adopted",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto"),
                      ),
                    )
                  : Container(),
            )
          ],
        )
      ],
    ),
  );
}
