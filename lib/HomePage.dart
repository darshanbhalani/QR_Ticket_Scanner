import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:QR_Ticket_Scanner/Const.dart';
import 'package:QR_Ticket_Scanner/SettingsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Map data = {};
  bool? flag;
  bool? flag1 = isNull!;
  String? status;
  late AudioPlayer audioPlayer;
  bool isLoading=true;
  bool isExit=false;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioPlayer = AudioPlayer();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (context) => AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.exit_to_app),
              SizedBox(width: 5,),
              Text("Exit App"),
            ],
          ),
          content: const Text("Sure you want to Exit App ?"),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child:Text("No",style:TextStyle(color: c1),)),
            TextButton(
                onPressed: () async {
                  isExit=true;
                  setState(() {});
                  exit(0);
                },
                child:Text("Yes",style: TextStyle(color: c1),))
          ],
        ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QR Scanner"),
          backgroundColor: c1,
          actions: [
            GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Icon(Icons.refresh),
                )),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Icon(Icons.settings),
                ))
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              // child: _buildQrView(context)
              child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300),
                onQRViewCreated: (QRViewController controller) {
                  this.controller = controller;
                    controller.scannedDataStream.listen((scanData) {
                     if(!isNull!){
                       setState(() {
                         result = scanData;
                         if (flag == null) {
                           checkQR();
                         }
                       });
                     }else{
                       if(flag1!){
                         flag1=false;
                         setState(() {});
                         snackBar(context, Colors.red, "Please select data.");
                         Timer(const Duration(seconds: 2), () {
                           flag1=true;
                           setState(() {});
                         });
                       }
                     }
                    });

                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'City Name : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20),
                      ),
                      TextSpan(
                        text: cityName.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Station Name : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20),
                      ),
                      TextSpan(
                        text: stationName.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Gate Name : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20),
                      ),
                      TextSpan(
                        text: gateName.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: flag == null || status == null
                              ? Colors.grey
                              : status == "Pass"
                                  ? Colors.green
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 80,
                    width: 200,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: flag == null || status == null
                          ? Colors.grey
                          : status == "Pass"
                              ? Colors.green
                              : Colors.red,
                    )),
                    child: Center(
                        child: Text(
                      status ?? "",
                      style: TextStyle(
                          color:
                              status == "Invalid" ? Colors.red : Colors.green,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1),
                    )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  checkQR() async {
    flag = true;
    isLoading=false;
    setState(() {});
    loading(context,isLoading);
    List temp = [];
    data = {};
    try {
      setState(() {});
      temp = result!.code!.split("::");
      data["Metro"] = temp[0].toString().split("-")[0].toString();
      data["Id"] = temp[1];
      data["Source"] = temp[2].toString().split("-")[0].toString();
      data["Destination"] = temp[2].toString().split("-")[1].toString();
      if (data["Metro"] == cityName.toString() && gateName.toString() == "Entry"
          ? data["Source"].toString() == stationName
          : data["Destination"].toString() == stationName) {
        var snapshot = await fire
            .collection("qr-ticket-data")
            .doc(data["Id"].toString())
            .get();
        if (snapshot.exists) {
          audioPlayer.play(AssetSource("assets/Single.mp3"));
          status = "Pass";
          setState(() {});
          if (gateName == "Exit") {
            String? tempNum;
            await fire
                .collection("qr-ticket-data")
                .doc(data["Id"].toString())
                .get()
                .then((value) {
              tempNum = value["Tickets"];
            });
            if (double.parse(tempNum.toString()) > 1.0) {
              await fire
                  .collection("qr-ticket-data")
                  .doc(data["Id"].toString())
                  .update({
                "Tickets": (double.parse(tempNum.toString()) - 1).toString()
              });
            } else {
              await fire.collection("qr-ticket-data").doc(data["Id"]).delete();
            }
          }
          isLoading=true;
          Navigator.pop(context);
          setState(() {});
          Timer(const Duration(seconds: 5), () {
            flag = null;
            status = null;
            setState(() {});
          });
        } else {
          tempBack();
        }
      } else {
        tempBack();
      }
    } catch (e) {
      tempBack();
    }
  }

  tempBack() async {
    Navigator.pop(context);
    await audioPlayer.play(AssetSource("assets/Long.mp3"));
    status = "Invalid";
    Timer(const Duration(seconds: 2), () {
      flag = null;
      status = null;
      audioPlayer.stop();
      isLoading=true;
      setState(() {});
    });
  }

}
