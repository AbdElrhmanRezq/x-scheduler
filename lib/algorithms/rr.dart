import 'dart:collection';

import 'package:os_project/models/process.dart';

class RRProcess {
  int burstTime;
  int arrivalTime;
  int processId;
  late int turnaroundTime;
  late int waitingTime;
  List<int> startTime = [];
  List<int> endTime = [];
  List<int> remainingTime = [];

  RRProcess(this.burstTime, this.arrivalTime, this.processId) {
    remainingTime.add(burstTime);
  }
}

class RRAlgorithm {
  int repeatCounter = 0;
  int time = 0;
  late int size;
  late RRProcess tempP;
  Queue<RRProcess> processesQueue = Queue<RRProcess>();
  List<RRProcess> processes = [];
  int numberOfProcesses;
  int quantum;
  List<int> ganttProcesses = [];

  RRAlgorithm(this.numberOfProcesses, this.quantum);

  void setInitialData(List<Process> providerProcesses) {
    for (var i = 0; i < numberOfProcesses; i++) {
      RRProcess process = RRProcess(providerProcesses[i].duration,
          providerProcesses[i].arrivalTime, i + 1);
      processes.add(process);
    }
  }

  void addProcess(int arrivalTime, int burstTime) {
    RRProcess added = RRProcess(burstTime, arrivalTime, processes.length + 1);
    processes.add(added);
  }

  // Future<void> calculateStartTimeLive() async {
  //   Queue<RRProcess> processesQueue = Queue.from(processes);

  //   int time = 0;
  //   int repeatCounter = 0;
  //   while (true) {
  //     if (processes.length != processesQueue.length) {
  //       processesQueue.add(processes.last);
  //       processes.length = processesQueue.length;
  //       numberOfProcesses = processes.length;
  //     }

  //     await Future.delayed(Duration(seconds: 1));
  //     RRProcess tempP = processesQueue.first;
  //     if (tempP.arrivalTime <= time) {
  //       repeatCounter = 0;
  //       tempP.startTime.add(time);
  //       if (tempP.burstTime >= quantum) {
  //         tempP.endTime.add(time + quantum);
  //         time += quantum;
  //         tempP.burstTime -= quantum;
  //       } else {
  //         int restQuantum = quantum - tempP.burstTime;
  //         tempP.burstTime = 0;
  //         time += restQuantum;
  //         tempP.endTime.add(time);
  //       }
  //       tempP.remainingTime.add(tempP.burstTime);
  //       stdout.write('p${tempP.processId} (${tempP.remainingTime.last}) | ');

  //       if (tempP.burstTime <= 0) {
  //         processesQueue.removeFirst();
  //       } else {
  //         processesQueue.add(tempP);
  //         processesQueue.removeFirst();
  //       }
  //       if (processesQueue.isEmpty) {
  //         break;
  //       }
  //     } else {
  //       repeatCounter++;
  //       processesQueue.add(tempP);
  //       processesQueue.removeFirst();
  //       if (repeatCounter == processesQueue.length) {
  //         time++;
  //       }
  //     }
  //   }
  // }

  void calculateStartTimeNonLive() {
    Queue<RRProcess> processesQueue = Queue.from(processes);

    int time = 0;
    int repeatCounter = 0;
    while (true) {
      RRProcess tempP = processesQueue.first;
      if (tempP.arrivalTime <= time) {
        repeatCounter = 0;
        tempP.startTime.add(time);
        if (tempP.burstTime >= quantum) {
          tempP.endTime.add(time + quantum);
          time += quantum;
          for (var i = 0; i < quantum; i++) {
            ganttProcesses.add(tempP.processId);
          }
          tempP.burstTime -= quantum;
        } else {
          int restQuantum = quantum - tempP.burstTime;
          tempP.burstTime = 0;
          time += restQuantum;
          for (var i = 0; i < quantum; i++) {
            ganttProcesses.add(tempP.processId);
          }
          tempP.endTime.add(time);
        }
        tempP.remainingTime.add(tempP.burstTime);

        if (tempP.burstTime <= 0) {
          processesQueue.removeFirst();
        } else {
          processesQueue.add(tempP);
          processesQueue.removeFirst();
        }
        if (processesQueue.isEmpty) {
          break;
        }
      } else {
        repeatCounter++;
        processesQueue.add(tempP);
        processesQueue.removeFirst();
        if (repeatCounter == processesQueue.length) {
          time++;
        }
      }
    }
  }

  // void liveRR() async {
  //   //await calculateStartTimeLive();
  //   calculateTurnaroundTime();
  //   calculateWaitingTime();
  //   printRR();
  // }

  void nonLiveRR() {
    calculateStartTimeNonLive();
    calculateTurnaroundTime();
    calculateWaitingTime();
  }

  void calculateTurnaroundTime() {
    for (var process in processes) {
      process.turnaroundTime = (process.endTime.last - process.arrivalTime);
    }
  }

  void calculateWaitingTime() {
    for (var process in processes) {
      process.waitingTime = process.turnaroundTime - process.burstTime;
    }
  }

  // void printRR() {
  //   print('******Remaining Time******');
  //   for (var process in processes) {
  //     for (var remainingTime in process.remainingTime) {
  //       stdout.write('$remainingTime|');
  //     }
  //     print('');
  //   }

  //   print('******start & finish time******');
  //   for (var process in processes) {
  //     print('start: p${process.processId} --> ${process.startTime.first}');
  //     print('end: p${process.processId} --> ${process.endTime.last}');
  //     print(
  //         'waiting Time: ${process.waitingTime}, turnaround Time: ${process.turnaroundTime}');
  //   }
  // }

  List<RRProcess> getProcesses() {
    return processes;
  }

  void queueInit() {
    for (int i = 0; i < processes.length; ++i) {
      processesQueue.add(processes[i]);
    }
    size = processes.length;
  }

  bool isQueueEmpty() {
    return processesQueue.isEmpty;
  }

  String calcStartTimeLive() {
    while (true) {
      if (size != processes.length) {
        processesQueue.add(processes.last);
        size = processes.length;
      }
      if (processesQueue.isEmpty) {
        return "IDLE";
      }

      tempP = processesQueue.first;
      if (tempP.arrivalTime <= time) {
        repeatCounter = 0;
        processes[tempP.processId - 1].startTime.add(time);
        if (tempP.burstTime >= quantum) {
          processes[tempP.processId - 1].endTime.add(time + quantum);
          time += quantum;
          // for (var i = 0; i < quantum; i++) {
          //   ganttProcesses.add("P${tempP.processId}");
          // }
          tempP.burstTime -= quantum;
        } else {
          var restQuantum = quantum - tempP.burstTime; //abs
          tempP.burstTime = 0;
          time += restQuantum;
          // for (var i = 0; i < quantum; i++) {
          //   ganttProcesses.add("P${tempP.processId}");
          // }
          processes[tempP.processId - 1].endTime.add(time);
        }
        processes[tempP.processId - 1].remainingTime.add(tempP.burstTime);
        // print(
        //     "p${tempP.processId}(${processes[tempP.processId - 1].remainingTime.last}) |");

        if (tempP.burstTime <= 0) {
          processesQueue.removeFirst();
        } else {
          processesQueue.add(tempP);
          processesQueue.removeFirst();
        }
        if (processesQueue.isEmpty) {
          //return "IDLE";
        }
        break;
      } else {
        repeatCounter++;
        processesQueue.add(tempP);
        processesQueue.removeFirst();
        if (repeatCounter == processesQueue.length) {
          time++;
        }
        // return "";
      }
    }
    return "p${tempP.processId}";
  }
}

// void main() {
//   stdout.write('Enter the number of processes: ');
//   int numProcesses = int.parse(stdin.readLineSync());
//   stdout.write('Enter the time quantum: ');
//   int quantum = int.parse(stdin.readLineSync());

//   RRAlgorithm rrAlgorithm = RRAlgorithm(numProcesses, quantum);

//   rrAlgorithm.getDataGUI();
//   // rrAlgorithm.liveRR();
//   rrAlgorithm.nonLiveRR();
// }
/*
void setInitialData(List<Process> providerProcesses) {
    for (var i = 0; i < numOfProcesses; i++) {
      RRProcess process = RRProcess(providerProcesses[i].duration,
          providerProcesses[i].arrivalTime, i + 1);
      processes.add(process);
    }
  }

*/ 