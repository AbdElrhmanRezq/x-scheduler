import 'dart:io';
import 'dart:core';
import 'package:os_project/models/process.dart';

/***********************Struct_Process**********************************/
class NonP_Priority_Process {
  int priority;
  double arrivalTime;
  int processNum;
  late int startTime;
  int burstTime;
  bool done;

  NonP_Priority_Process(this.priority, this.arrivalTime, this.processNum,
      this.burstTime, this.done);
}

/*************************************Helpers**********************************************************/
int sortByArrivalAndPriority(NonP_Priority_Process a, NonP_Priority_Process b) {
  if (a.arrivalTime != b.arrivalTime) {
    return a.arrivalTime.compareTo(b.arrivalTime);
  } else {
    return a.priority.compareTo(b.priority);
  }
}

int sortByStartAndPriority(NonP_Priority_Process a, NonP_Priority_Process b) {
  if (b.arrivalTime < a.startTime && b.priority > a.priority) {
    return -1;
  } else if (b.arrivalTime > a.startTime && b.priority < a.priority) {
    return 1;
  } else {
    return 0;
  }
}

/************************NonPreemptive_Priority_CPU_Scheduler*************************/
class NonPreemptive_Priority {
  List<NonP_Priority_Process> processes = [];
  List<double> turnaround = [];
  List<double> waiting = [];
  double averageWaiting = 0.0;
  double averageTurnaround = 0.0;
  int numberOfProcesses;

  /*****constructor********/
  NonPreemptive_Priority(this.numberOfProcesses);

  double averageTurnaroundTime() {
    double sum = 0;
    for (int i = 0; i < numberOfProcesses; i++) {
      sum += processes[i].burstTime - processes[i].arrivalTime;
      turnaround.add(processes[i].burstTime - processes[i].arrivalTime);
    }
    averageTurnaround = sum / numberOfProcesses;
    return averageTurnaround;
  }

  double averageWaitingTime() {
    double sum = 0;
    for (int i = 0; i < numberOfProcesses; i++) {
      sum += processes[i].startTime - processes[i].arrivalTime;
      waiting.add(processes[i].startTime - processes[i].arrivalTime);
    }
    averageWaiting = sum / numberOfProcesses;
    return averageWaiting;
  }

  /****************************methods********************************/
  void getData(List<Process> providerProcess) {
    for (int i = 0; i < numberOfProcesses; i++) {
      processes.add(NonP_Priority_Process(
          providerProcess[i].priority as int,
          providerProcess[i].arrivalTime.toDouble(),
          i + 1,
          providerProcess[i].duration,
          false));
    }
    sort();
  }

  void sort() {
    processes.sort(sortByArrivalAndPriority);

    for (int i = 0; i < numberOfProcesses; i++) {
      if (i == 0) {
        processes[i].startTime = processes[i].arrivalTime.toInt();
      } else {
        processes[i].startTime = (processes[i].arrivalTime >
                processes[i - 1].burstTime + processes[i - 1].startTime)
            ? processes[i].arrivalTime.toInt()
            : (processes[i - 1].burstTime + processes[i - 1].startTime);
      }
    }

    processes.sort(sortByStartAndPriority);
    for (int i = 0; i < numberOfProcesses; i++) {
      if (i == 0) {
        processes[i].startTime = processes[i].arrivalTime.toInt();
      } else {
        processes[i].startTime = (processes[i].arrivalTime >
                processes[i - 1].burstTime + processes[i - 1].startTime)
            ? processes[i].arrivalTime.toInt()
            : (processes[i - 1].burstTime + processes[i - 1].startTime);
      }
    }
  }

  void aging() {
    const int agingFactor = 1;
    for (var p in processes) {
      if (!p.done) p.priority -= agingFactor;
    }
  }

  void addNewProcess(int arrivalTime, int burstTime, int priority) {
    processes.add(NonP_Priority_Process(priority, arrivalTime.toDouble(),
        numberOfProcesses + 1, burstTime, false));
    numberOfProcesses++;
    sort();
    aging();
  }

  void printProcesses() {
    for (int i = 0; i < numberOfProcesses; i++) {
      stdout.write("${processes[i].processNum} ");
      processes[i].done = true;
    }
    print("");
  }

  List<int> getTimeLine(List<NonP_Priority_Process> processes) {
    List<int> timeLineProcesses = [];

    for (var p in processes) {
      for (var i = 0; i < p.burstTime; i++) {
        timeLineProcesses.add(p.processNum);
      }
    }

    return timeLineProcesses;
  }

  List<NonP_Priority_Process> getProcesses() {
    return processes;
  }
}

// void main() {
//   var test1 = NonPreemptive_Priority(5); //class ..enter number of processes

//   //test1.getData(); // get data from user

//   test1
//       .printProcesses(); //just to see it will sort it right (we will not use it)

//   test1.getProcesses(); // return processes ready to enter cpu
// }
