import 'package:flutter/material.dart';
import 'package:page_indicator_test_1/screen/page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> itemsWidget() {
    var list = <Widget>[];
    for (var i = 0; i < 3; i++) {
      list.add(
        Center(
          child: Text(
            '${i} Page',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PageView indicator....',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            PageViewIndicator(
              backGroundColor: Colors.blue,
              indicatorBackgroundColor: Colors.grey,
              indicatorColor: Colors.red,
              itemCount: 3,
              child: itemsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
