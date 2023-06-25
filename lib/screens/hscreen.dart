import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/widgets/console_widgets/joystick_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_joystick/flutter_joystick.dart';

import 'package:toggle_switch/toggle_switch.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/AppBarConsole/console_appbar.dart';
import '../components/Joystick/FourDirectionJoystick.dart';

class HomePageCosole extends StatefulWidget {
  const HomePageCosole({Key? key}) : super(key: key);

  @override
  State<HomePageCosole> createState() => _HomePageCosoleState();
}

class _HomePageCosoleState extends State<HomePageCosole> {
  double _lefthand = 0;
  double _righthand = 0;
  int valInt1 = 0;
  int valInt2 = 0;


  final databaseReference = FirebaseDatabase.instance.reference();

  void _updateSliderValue(double value) {
    setState(() {
      _lefthand = value;
      valInt1 = value.toInt();
    });
    _updateFirebaseValue('lefthand', valInt1.toString());
  }

  void _updateSliderValueRight(double value) {
    setState(() {
      _righthand = value;
      valInt2 = value.toInt();
    });
    _updateFirebaseValue('righthand', valInt2.toString());
  }

  void _updateFirebaseValue(String fieldName, String value) {
    // Update the value in Firebase Realtime Database
    databaseReference.update({fieldName: value});
  }

  late WebViewController _controller;
  bool booleanValue = false;
  DatabaseReference? _ref;

  static const labels = ['on', 'off', 'auto'];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://stistcam.serveo.net/0/stream')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://stistcam.serveo.net/0/stream'));
    _ref = FirebaseDatabase.instance.ref();
  }

  // HomePage({super.key});
  void callback(x, y) {
    log('callback x => $x and y $y');
  }

  Future<void> initializeFirebase() async {
    // await Firebase.initializeApp();

    // _databaseReference = FirebaseDatabase.instance.ref().child('');
  }

  void updateon() {
    _ref!.update({'ON': true});
    debugPrint(_ref.toString());
  }

  void updateoff() {
    _ref!.update({'OFF': true});
    debugPrint(_ref.toString());
  }

  void updateauto() {
    _ref!.update({'AT': true});
    debugPrint(_ref.toString());
  }

  void updateDb(Map<String, dynamic> data) {
    _ref!.update(data).toString();
  }

  // final user = FirebaseAuth.instance.currentUser!;
  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: FutureBuilder(
              future: _ref!.get(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                final data = snapshot.data!.value as Map<dynamic, dynamic>;



                String alarmmode = data['alarmmode'] ?? 'off';
                String lightmode = data['lightmode'] ?? 'off';
                String lockermode = data['lockermode'] ?? 'off';
                bool vaccum = data['vaccum'] ?? false;


                return Column(
                  children: [
                    const ConsoleAppBar(),
                    Expanded(
                      child: Stack(
                        children: [



                               WebViewWidget(controller: _controller),
                              // Container(color: Colors.red),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Slider(
                                      min: 0,
                                      max: 180,
                                      value: _lefthand,
                                      onChanged: _updateSliderValue,
                                    ),
                                    ToggleSwitch(
                                      iconSize: 15.0,
                                      minWidth: 60.0,
                                      cornerRadius: 20.0,
                                      inactiveFgColor: Colors.white,
                                      activeBgColors: const [
                                        [Colors.green],
                                        [Colors.red],
                                        [Colors.orange]
                                      ],
                                      icons: const [
                                        Icons.lightbulb,
                                        Icons.lightbulb_outline,
                                        Icons.hdr_auto_rounded
                                      ],
                                      initialLabelIndex:
                                          labels.indexOf(lightmode),
                                      totalSwitches: 3,
                                      labels: labels,
                                      customTextStyles: const [
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w900)
                                      ],
                                      onToggle: (index) {
                                        switch (index) {
                                          case 0:
                                            updateDb({'lightmode': 'on'});
                                            break;
                                          case 1:
                                            updateDb({'lightmode': 'off'});
                                            break;
                                          case 2:
                                            updateDb({'lightmode': 'auto'});
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    ToggleSwitch(
                                      // changeOnTap: true,

                                      iconSize: 15.0,
                                      minWidth: 60.0,
                                      cornerRadius: 20.0,
                                      activeBgColors: const [
                                        [Colors.green],
                                        [Colors.red],
                                        [Colors.orange]
                                      ],
                                      icons: const [
                                        Icons.alarm_on,
                                        Icons.alarm_off,
                                        Icons.hdr_auto_rounded
                                      ],
                                      inactiveFgColor: Colors.white,
                                      initialLabelIndex:
                                          labels.indexOf(alarmmode),
                                      totalSwitches: 3,
                                      labels: labels,
                                      customTextStyles: const [
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w900),
                                      ],
                                      onToggle: (index) {
                                        switch (index) {
                                          case 0:
                                            updateDb({'alarmmode': 'on'});
                                            break;
                                          case 1:
                                            updateDb({'alarmmode': 'off'});
                                            break;
                                          case 2:
                                            updateDb({'alarmmode': 'auto'});
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    ToggleSwitch(
                                      iconSize: 15.0,
                                      minWidth: 60.0,
                                      cornerRadius: 20.0,
                                      activeBgColors: const [
                                        [Colors.green],
                                        [Colors.red],
                                        [Colors.orange]
                                      ],
                                      icons: const [
                                        Icons.lock,
                                        Icons.lock_open,
                                        Icons.hdr_auto_rounded
                                      ],
                                      inactiveFgColor: Colors.white,
                                      initialLabelIndex:
                                          labels.indexOf(lockermode),
                                      totalSwitches: 3,
                                      labels: labels,
                                      customTextStyles: const [
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w900),
                                      ],
                                      onToggle: (index) {
                                        switch (index) {
                                          case 0:
                                            updateDb({'lockermode': 'on'});
                                            break;
                                          case 1:
                                            updateDb({'lockermode': 'off'});
                                            break;
                                          case 2:
                                            updateDb({'lockermode': 'auto'});
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    ToggleSwitch(
                                      minWidth: 60.0,
                                      initialLabelIndex: vaccum ? 0 : 1,
                                     // initialLabelIndex:
                                       //   labels.indexOf(vaccum.toString()),
                                      cornerRadius: 20.0,
                                      activeFgColor: Colors.black,
                                      inactiveBgColor: Colors.grey,
                                      inactiveFgColor: Colors.white,
                                      totalSwitches: 2,
                                      labels: const ['', 'off'],
                                      icons: const [
                                        Icons.cleaning_services,
                                        Icons.clear
                                      ],
                                      activeBgColors: const [
                                        [Colors.green],
                                        [Colors.red]
                                      ],
                                      onToggle: (index) {
                                        switch (index) {

                                          case 0:
                                            updateDb({'vaccum': true});
                                            break;
                                          case 1:
                                            updateDb({'vaccum': false});
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Slider(
                                      value: _righthand,
                                      min: 0,
                                      max: 180,
                                      onChanged: _updateSliderValueRight,
                                    ),
                                    //JoystickH(),
                                    Joystick(
                                      mode: JoystickMode.horizontalAndVertical,
                                      base: JoystickSquareBase(mode: JoystickMode.horizontalAndVertical),
                                      stickOffsetCalculator: const RectangleStickOffsetCalculator(),
                                      listener: (details) {
                                        double dx = details.x;
                                        double dy = details.y;

                                        if (dx > 0) {
                                          print("Move right");
                                          updateDb({'movement': 'r'});
                                        } else if (dx < 0) {
                                          print("Move left");
                                          updateDb({'movement': 'l'});
                                        }

                                        if (dy > 0) {
                                          print("Move backward");
                                          updateDb({'movement': 'b'});
                                        } else if (dy < 0) {
                                          print("Move forward");
                                          updateDb({'movement': 'f'});
                                        }
                                        else if (dx == 0 && dy == 0)  {
                                          print("stationary");
                                          print(dx);
                                          print(dy);
                                          updateDb({'movement': 's'});
                                        }
                                      },
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
