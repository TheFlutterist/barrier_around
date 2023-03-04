import 'package:barrier_around/barrier_around.dart';
import 'package:flutter/material.dart';

class BarrierAroundManager {
  static void showBarrier(GlobalKey barrierAroundKey) {
    if (barrierAroundKey.currentState == null) {
      throw Exception(
          "The BarrierAround key provided must be a GlobalKey of a BarrierAround widget.");
    }

    final barrierAroundState =
        barrierAroundKey.currentState as BarrierAroundState;

    barrierAroundState.showBarrier();
  }

  static void dismissBarrier(GlobalKey barrierAroundKey) {
    if (barrierAroundKey.currentState == null) {
      throw Exception(
          "The BarrierAround key provided must be a GlobalKey of a BarrierAround widget.");
    }

    final barrierAroundState =
        barrierAroundKey.currentState as BarrierAroundState;

    barrierAroundState.dismissBarrier();
  }
}
