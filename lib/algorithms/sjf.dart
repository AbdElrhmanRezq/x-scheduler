import 'dart:io';
import 'package:os_project/models/process.dart';

class SJFProcess {
  int burstTime;
  int arrivalTime;
  int processNum;
  int startTime = 0;
  int remainingTime = 0;
  int completionTime = 0;
  int waitingTime = 0;
  int turnaroundTime = 0;

  SJFProcess(this.burstTime, this.arrivalTime, this.processNum) {
    remainingTime = burstTime;
  }
}

class SJF {
  List<SJFProcess> processes = [];
  List<int> timeline = [];
  int numOfProcess;
  double avgWaitingTime = 0;
  double avgTurnaroundTime = 0;

  SJF(this.numOfProcess);

  void getData(List<Process> providerProcesses) {
    for (int i = 0; i < numOfProcess; i++) {
      SJFProcess p = SJFProcess(
        providerProcesses[i].duration,
        providerProcesses[i].arrivalTime,
        i + 1,
      );
      processes.add(p);
    }
  }

  void addProcess(int arrivalTime, int burstTime) {
    SJFProcess p = SJFProcess(
      burstTime,
      arrivalTime,
      numOfProcess + 1,
    );
    processes.add(p);
    numOfProcess++;
    execute(); // Recalculate the timeline after adding the new process
  }

  void execute() {
    int currentTime = 0;
    int completed = 0;

    while (completed != numOfProcess) {
      int shortest = -1;
      int minBurst = 999999;

      for (int i = 0; i < numOfProcess; i++) {
        if (processes[i].arrivalTime <= currentTime &&
            processes[i].remainingTime < minBurst &&
            processes[i].remainingTime > 0) {
          minBurst = processes[i].remainingTime;
          shortest = i;
        }
      }

      if (shortest == -1) {
        currentTime++;
        continue;
      }

      processes[shortest].remainingTime--;

      if (processes[shortest].remainingTime == 0) {
        completed++;
        int finishTime = currentTime + 1;
        processes[shortest].completionTime = finishTime;
        processes[shortest].turnaroundTime =
            finishTime - processes[shortest].arrivalTime;
        processes[shortest].waitingTime =
            processes[shortest].turnaroundTime - processes[shortest].burstTime;
      }

      timeline.add(shortest + 1);
      currentTime++;
    }

    // Calculate average waiting time and average turnaround time
    for (int i = 0; i < numOfProcess; i++) {
      avgWaitingTime += processes[i].waitingTime;
      avgTurnaroundTime += processes[i].turnaroundTime;
    }

    avgWaitingTime /= numOfProcess;
    avgTurnaroundTime /= numOfProcess;
  }

  void printTimeline() {
    print('Timeline:');
    for (int i = 0; i < timeline.length; i++) {
      stdout.write('P${timeline[i]} ');
    }
    print('');
  }

  void printSJF() {
    print(
        'Process\tArrival Time\tBurst Time\tCompletion Time\tWaiting Time\tTurnaround Time');
    for (int i = 0; i < numOfProcess; i++) {
      print(
          '${processes[i].processNum}\t${processes[i].arrivalTime}\t\t${processes[i].burstTime}\t\t${processes[i].completionTime}\t\t${processes[i].waitingTime}\t\t${processes[i].turnaroundTime}');
    }
    print('Average Waiting Time: $avgWaitingTime');
    print('Average Turnaround Time: $avgTurnaroundTime');
  }
}

void main() {
  print('Enter the number of processes:');
  int numOfProcess = int.parse(stdin.readLineSync()!);
  SJF sjf = SJF(numOfProcess);

  for (int i = 0; i < numOfProcess; i++) {
    print('Enter arrival time for process ${i + 1}:');
    int arrivalTime = int.parse(stdin.readLineSync()!);

    print('Enter burst time for process ${i + 1}:');
    int burstTime = int.parse(stdin.readLineSync()!);

    sjf.addProcess(arrivalTime, burstTime);
  }

  sjf.execute();
  sjf.printTimeline();
  sjf.printSJF();
}
