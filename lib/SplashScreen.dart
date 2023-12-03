import 'package:flutter/material.dart';
import 'package:QR_Ticket_Scanner/HomePage.dart';
import 'package:provider/provider.dart';

import 'Const.dart';
import 'ProviderClass.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    var DataProviderModel = Provider.of<DataProvider>(context, listen: false);
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController!.forward();
    _animationController!.addStatusListener((status) async {
      if(DataProviderModel.cityName==null || DataProviderModel.stationName==null || DataProviderModel.gateName==null){
        isNull=true;
      }
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _animationController!,
              child: child,
            ),
          ),
        );
      },
      child: const YourSplashScreenContent(), // Replace with your own splash screen content
    );
  }
}

class YourSplashScreenContent extends StatelessWidget {
  const YourSplashScreenContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            top: 200,
            right: 200,
            child: Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(
                  color: c2,
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                  color: c2,
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            bottom: -250,
            right: -250,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                  color: c2,
                  shape: BoxShape.circle
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image.asset('assets/assets/logo.png')),
                const Text("MetroX QR-Ticket Scanner",textAlign:TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
