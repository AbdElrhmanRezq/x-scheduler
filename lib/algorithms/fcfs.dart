import 'dart:io';
import 'package:os_project/models/process.dart';

class FCFSProcess {
  int burstTime;
  int arrivalTime;
  int processNum;
  int startTime;

  FCFSProcess({
    required this.burstTime,
    required this.arrivalTime,
    required this.processNum,
    required this.startTime,
  });
}

class FCFS {
  List<FCFSProcess> processes = [];
  int numOfProcess;
  List<int> startTime = [];
  List<int> endTime = [];
  List<int> waitingTime = [];
  List<int> turnaroundTime = [];
  double avgWaitingTime = 0;
  double avgTurnaround = 0;
  bool flagAdded = true;
  int globalI = 0;
  List<int> timeLine = [];

  FCFS(this.numOfProcess);

  void getData(List<Process> providerProcesses) {
    for (int i = 0; i < numOfProcess; i++) {
      FCFSProcess p = FCFSProcess(
        arrivalTime: providerProcesses[i].arrivalTime,
        burstTime: providerProcesses[i].duration,
        processNum: i + 1,
        startTime: 0,
      );
      processes.add(p);
    }
  }

  void sortProcesses() {
    processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
  }

  void calcStartAndEndTime() {
    for (int i = 0; i < numOfProcess; i++) {
      if (i == 0) {
        processes[i].startTime = processes[i].arrivalTime;
        startTime.add(processes[i].startTime);
        endTime.add(processes[i].startTime + processes[i].burstTime);
      } else if (processes[i].arrivalTime <
          processes[i - 1].startTime + processes[i - 1].burstTime) {
        processes[i].startTime =
            processes[i - 1].startTime + processes[i - 1].burstTime;
        startTime.add(processes[i].startTime);
        endTime.add(processes[i].startTime + processes[i].burstTime);
      } else {
        processes[i].startTime = processes[i].arrivalTime;
        startTime.add(processes[i].startTime);
        endTime.add(processes[i].startTime + processes[i].burstTime);
      }
    }
  }

  void calcWaitingTime() {
    for (int i = 0; i < numOfProcess; i++) {
      waitingTime.add(startTime[i] - processes[i].arrivalTime);
      avgWaitingTime += waitingTime[i];
    }
    avgWaitingTime = avgWaitingTime / numOfProcess;
  }

  void calcTurnaround() {
    for (int i = 0; i < numOfProcess; i++) {
      turnaroundTime.add(endTime[i] - processes[i].arrivalTime);
      avgTurnaround += turnaroundTime[i];
    }
    avgTurnaround = avgTurnaround / numOfProcess;
  }

  void fcfsCalculations() {
    sortProcesses();
    calcStartAndEndTime();
    calcTurnaround();
    calcWaitingTime();
  }

  void addNewProcess(int arrivalTime, int burstTime) {
    flagAdded = false;

    FCFSProcess p = FCFSProcess(
      arrivalTime: arrivalTime,
      burstTime: burstTime,
      processNum: numOfProcess + 1,
      startTime: 0,
    );
    processes.add(p);
    numOfProcess++;
    startTime.clear();
    endTime.clear();
    waitingTime.clear();
    turnaroundTime.clear();
    avgTurnaround = 0;
    avgWaitingTime = 0;
    fcfsCalculations();
    timeLine.clear();
    fcfsLiveCalculation();
  }

  void fcfsLiveCalculation() {
    int count = 0;
    for (int i = 0; i < endTime.last; i++) {
      if (count != numOfProcess - 1) {
        if (i >= endTime[count] && i < processes[count + 1].startTime) {
          timeLine.add(0);
        } else if (i < processes[count + 1].startTime) {
          if (i < processes[count].startTime) {
            timeLine.add(0);
          } else {
            timeLine.add(processes[count].processNum);
          }
        } else {
          if (count != numOfProcess - 1) count++;
          timeLine.add(processes[count].processNum);
        }
      } else {
        if (count != numOfProcess - 1) count++;
        timeLine.add(processes[count].processNum);
      }
    }
  }

  void printTimeLine() {
    if (!flagAdded) {
      timeLine.clear();
      fcfsLiveCalculation();
      flagAdded = true;
    }
    if (timeLine[globalI] == 0) {
      stdout.write("idle ");
    } else {
      stdout.write("P${timeLine[globalI]} ");
    }
    globalI++;
  }

  void printFCFS() {
    print("\nturnaround       waiting\n ");
    for (int i = 0; i < numOfProcess; i++) {
      print("${turnaroundTime[i]}\t\t${waitingTime[i]}");
    }
    print("avg Waiting time = $avgWaitingTime");
    print("avg Turnaround time = $avgTurnaround");
  }

  int getLastEndTime() {
    return endTime.last;
  }
}

void main() {
  int numOfProcess = int.parse(stdin.readLineSync()!);
  FCFS fcfs = FCFS(numOfProcess);
  //fcfs.getData();
  fcfs.fcfsCalculations();
  fcfs.fcfsLiveCalculation();
  for (int i = 0; i < fcfs.getLastEndTime(); i++) {
    if (i == 5) {
      //fcfs.addNewProcess();
    }
    fcfs.printTimeLine();
    sleep(Duration(seconds: 1));
  }
  fcfs.printFCFS();
}
