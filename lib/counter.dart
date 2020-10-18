import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer extends StatefulWidget {

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {


  int duration = 1;
  String datenow;
  double bronze;
  double silver;
  double gold;
  String userId;
  String calo = "";
  AnimationController controller;
  bool flag = false;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState()  {
    controls();
    super.initState();
  }

  controls() async{
    final DateTime now = DateTime.now();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString('id');
    });
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      datenow = DateFormat('yyyy-MM-dd').format(now);
      bronze = double.parse(variable.data()['bronze']);
      silver = double.parse(variable.data()['silver']);
      gold = double.parse(variable.data()['gold']);
      duration = int.parse(variable.data()['duration']);
    });
    documenter();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: duration),
    );
  }

  documenter() async{
    DocumentSnapshot vard = await FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).get();
    setState(() {
      calo = vard.data()["calo"];
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        leading: MaterialButton(onPressed: (){
          Navigator.pop(context);
        },color: Colors.transparent,child: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text("Lets go!!!"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black54,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                      Container(
                        color: Colors.black54,
                        height:
                        controller.value * MediaQuery.of(context).size.height,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: CustomPaint(
                                          painter: CustomTimerPainter(
                                            animation: controller,
                                            backgroundColor: Colors.white,
                                            color: themeData.indicatorColor,
                                          )),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Count Down Timer",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            timerString,
                                            style: TextStyle(
                                                fontSize: 112.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return FloatingActionButton.extended(
                                    onPressed: () {
                                      if(flag == false){
                                        setState(() {
                                          flag = true;
                                          bronze += 1;
                                          silver += 0.2;
                                          gold += 0.1;
                                        });
                                        FirebaseFirestore.instance.collection("users").doc(userId).update({
                                          "bronze" : bronze.toString(),
                                          "silver" : silver.toString(),
                                          "gold" : gold.toString(),
                                        }).catchError((onError){print("error in update");});
                                        FirebaseFirestore.instance.collection('users').doc(userId).collection('calories').doc(datenow).update({
                                          "calo" : (double.parse(calo) + (10.0*duration)).toString(),
                                        });
                                      }
                                      if (controller.isAnimating)
                                        controller.stop();
                                      else {
                                        controller.reverse(
                                            from: controller.value == 0.0
                                                ? 1.0
                                                : controller.value);
                                      }
                                    },
                                    icon: Icon(controller.isAnimating
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                    label: Text(
                                        controller.isAnimating ? "Pause" : "Play"));
                              }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}