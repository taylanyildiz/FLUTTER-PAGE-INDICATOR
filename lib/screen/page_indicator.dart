import 'package:flutter/material.dart';

class PageViewIndicator extends StatefulWidget {
  final Widget child;
  final int itemCount;

  const PageViewIndicator({
    Key key,
    @required this.itemCount,
    @required this.child,
  }) : super(key: key);
  @override
  _PageViewIndicatorState createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator>
    with TickerProviderStateMixin {
  PageController pageController;
  AnimationController controller;
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
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200.0,
          color: Colors.red,
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) async {
              pageController.animateToPage(page,
                  duration: Duration(milliseconds: 100), curve: Curves.linear);
              setState(() {});
            },
            itemCount: 4,
            itemBuilder: (context, index) => AnimatedBuilder(
              animation: pageController,
              builder: (context, child) {
                return widget.child;
              },
            ),
          ),
        ),
        SizedBox(height: 50.0),
        Container(
          height: 20.0,
          child: CustomPaint(
            painter: IndicatorPaint(
              pageCount: widget.itemCount,
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
  IndicatorPaint({
    this.pageCount,
    this.page,
  })  : indicatorPaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill,
        fillPaint = Paint()
          ..color = Colors.yellow
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
        indicatorLeftX,
        0.0,
        indicatorRightX,
        2 * radius,
        Radius.circular(radius),
      ),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
