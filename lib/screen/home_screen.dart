import 'package:flutter/material.dart';
import 'package:page_indicator_test_1/screen/page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              build: (index) {
                return Center(
                  child: Text(
                    '${index + 1} Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
