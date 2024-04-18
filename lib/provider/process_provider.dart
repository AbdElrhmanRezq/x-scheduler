import 'package:flutter/material.dart';
import 'package:os_project/models/process.dart';

class ProcessProvider extends ChangeNotifier {
  String algorithm = "FCFS";
  List<Process> processList = [];
  bool live = false;

  void clearProcesses() {
    processList = [];
  }

  void changeAlgo(String newAlgorithm) {
    algorithm = newAlgorithm;
    notifyListeners();
  }

  void changeState(bool newState) {
    live = newState;
    notifyListeners();
  }
}
