import 'dart:async';

import 'package:flutter/material.dart';

class PageViewIndicator extends StatefulWidget {
  final int itemCount;
  final Widget Function(int) build;
  Color bakcgroundColors;
  Color indicatorColor;
  Color indicatorBackgroundColor;
  PageViewIndicator({
    Key key,
    @required this.itemCount,
    @required this.build,
    Color backGroundColor,
    Color indicatorColor,
    Color indicatorBackgroundColor,
  })  : bakcgroundColors = backGroundColor ?? Colors.red,
        indicatorColor = indicatorColor ?? Colors.red,
        indicatorBackgroundColor = indicatorBackgroundColor ?? Colors.yellow,
        super(key: key);
  @override
  _PageViewIndicatorState createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator>
    with TickerProviderStateMixin {
  PageController pageController;
  AnimationController controller;
  int currentPage = 0;
  Animation animation;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer.periodic(
      Duration(seconds: 4),
      (timer) {
        if (currentPage < widget.itemCount) {
          currentPage++;
          pageController.animateToPage(currentPage,
              duration: Duration(milliseconds: 600), curve: Curves.linear);
        } else {
          currentPage = 0;
          pageController.jumpToPage(0);
        }
      },
    );
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200.0,
          color: widget.bakcgroundColors,
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) async {
              setState(() {
                currentPage = page;
              });
            },
            itemCount: widget.itemCount,
            itemBuilder: (context, index) => AnimatedBuilder(
              animation: pageController,
              builder: (context, child) {
                return widget.build(index);
              },
            ),
          ),
        ),
        SizedBox(height: 50.0),
        Container(
          height: 20.0,
          child: CustomPaint(
            painter: IndicatorPaint(
              indicatorColor: widget.indicatorColor,
              indicatorBackgroundColor: widget.indicatorBackgroundColor,
              pageCount: widget.itemCount,
              // ignore: invalid_use_of_protected_member
              page: pageController.hasListeners ? pageController.page : 0.0,
            ),
          ),
        ),
      ],
    );
  }
}

class IndicatorPaint extends CustomPainter {
  final int pageCount;
  final double page;
  final Paint indicatorPaint;
  final Paint fillPaint;
  final double radius;
  final double space;
  final int thickness;
  final Color indicatorColor;
  final Color indicatorBackgroundColor;
  IndicatorPaint({
    this.indicatorBackgroundColor,
    this.indicatorColor,
    this.pageCount,
    this.page,
  })  : indicatorPaint = Paint()
          ..color = indicatorColor
          ..style = PaintingStyle.fill,
        fillPaint = Paint()
          ..color = indicatorBackgroundColor
          ..style = PaintingStyle.fill,
        radius = 10.0,
        space = 10,
        thickness = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);

    final double totalWidth =
        (pageCount * 2 * radius) + ((pageCount - 1) * space);
    _drawing(canvas, center, totalWidth);
    _drawPageIndicator(canvas, center, totalWidth);
  }

  void _drawing(Canvas canvas, Offset center, double totalWidth) {
    Offset circleCenter = center.translate((-totalWidth / 2) + radius, 0);
    for (var i = 0; i < pageCount; i++) {
      _drawEmptyCircle(canvas, circleCenter);
      circleCenter = circleCenter.translate((2 * radius) + space, 0);
    }
  }

  void _drawEmptyCircle(Canvas canvas, Offset circleCenter) {
    canvas.drawCircle(circleCenter, radius - thickness, fillPaint);
  }

  void _drawPageIndicator(Canvas canvas, Offset center, double totalWidht) {
    final int pageIndexToLeft = page.round();
    final double leftDotX = (center.dx - (totalWidht / 2)) +
        (pageIndexToLeft * ((2 * radius) + space));
    final double transitionPercent = page - pageIndexToLeft;
    final double indicatorLeftX =
        leftDotX + (transitionPercent * ((2 * radius) + space));
    final double indicatorRightX = indicatorLeftX + (2 * radius);

    canvas.drawRRect(
      RRect.fromLTRBR(
        indicatorLeftX + thickness,
        0.0 + thickness,
        indicatorRightX - thickness,
        2 * radius - thickness,
        Radius.circular(radius),
      ),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
