import 'package:barrier_around/barrier_around.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarrierAround Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: BarrierAroundShowcase(),
          ),
        ),
      ),
    );
  }
}

class BarrierAroundShowcase extends StatefulWidget {
  const BarrierAroundShowcase({super.key});

  @override
  State<BarrierAroundShowcase> createState() => _BarrierAroundShowcaseState();
}

class _BarrierAroundShowcaseState extends State<BarrierAroundShowcase> {
  static const textStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  final GlobalKey _redContainerBarrier = GlobalKey();
  final GlobalKey _greenContainerBarrier = GlobalKey();
  final GlobalKey _blueContainerBarrier = GlobalKey();

  bool tapped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _createRedContainer(),
          const SizedBox(height: 16.0),
          _createGreenContainer(),
          const SizedBox(height: 16.0),
          _createBlueContainer(),
        ],
      ),
    );
  }

  _createRedContainer() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BarrierAroundManager.showBarrier(_redContainerBarrier);
        },
        child: BarrierAround(
          key: _redContainerBarrier,
          animateBarrier: false,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.red.withOpacity(0.9),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "Animate: false",
                  style: textStyle,
                ),
                Text(
                  "Barrier blur: 0.0",
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createGreenContainer() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BarrierAroundManager.showBarrier(_greenContainerBarrier);
        },
        child: BarrierAround(
          key: _greenContainerBarrier,
          barrierBorderRadius: BorderRadius.circular(16.0),
          barrierBlur: 15.0,
          animationDuration: const Duration(seconds: 1),
          onBarrierTap: () {
            setState(() {
              tapped = true;
            });

            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                tapped = false;
              });
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16.0),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Animate: true",
                  style: textStyle,
                ),
                const Text(
                  "Animation duration: 1 second",
                  style: textStyle,
                ),
                const Text(
                  "Barrier blur: 15.0",
                  style: textStyle,
                ),
                const Text(
                  "Barrier border radius: 16.0",
                  style: textStyle,
                ),
                Text(
                  !tapped
                      ? "onBarrierTap: Not tapped yet..."
                      : "onBarrierTap: TAPPED!",
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createBlueContainer() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          BarrierAroundManager.showBarrier(_blueContainerBarrier);
        },
        child: BarrierAround(
          key: _blueContainerBarrier,
          barrierBorderRadius: BorderRadius.circular(32.0),
          barrierBlur: 5.0,
          barrierColor: Colors.teal,
          targetPadding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.9),
              borderRadius: BorderRadius.circular(32.0),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "Animate: true",
                  style: textStyle,
                ),
                Text(
                  "Barrier blur: 5.0",
                  style: textStyle,
                ),
                Text(
                  "Barrier border radius: 32.0",
                  style: textStyle,
                ),
                Text(
                  "Barrier color: teal",
                  style: textStyle,
                ),
                Text(
                  "Target padding: 4.0",
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
