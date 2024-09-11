import 'dart:async';

import 'package:flutter/material.dart';

enum TimerStatus { running, paused, stopped, resting }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const workSeconds = 25;
  static const restSeconds = 5;

  late TimerStatus _timerStatus;
  late int _timer;
  late int _pomodoroCount;

  @override
  void initState() {
    super.initState();
    _timerStatus = TimerStatus.stopped;
    _timer = workSeconds;
    _pomodoroCount = 0;
  }

  void runTimer() async {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      switch (_timerStatus) {
        case TimerStatus.paused:
        case TimerStatus.stopped:
          t.cancel();
          break;
        case TimerStatus.running:
          if (_timer <= 0) {
            rest();
          } else {
            setState(() {
              _timer -= 1;
            });
          }
          break;
        case TimerStatus.resting:
          if (_timer <= 0) {
            setState(() {
              _pomodoroCount += 1;
            });
            t.cancel();
            stop();
          } else {
            setState(() {
              _timer -= 1;
            });
          }
          break;
        default:
          break;
      }
    });
  }

  void run() {
    setState(() {
      _timerStatus = TimerStatus.running;
      print("[=>]" + _timerStatus.toString());
      runTimer();
    });
  }

  void rest() {
    setState(() {
      _timer = restSeconds;
      _timerStatus = TimerStatus.resting;
      print("[=>]" + _timerStatus.toString());
    });
  }

  void paused() {
    setState(() {
      _timerStatus = TimerStatus.paused;
    });
  }

  void resume() {
    run();
  }

  void stop() {
    setState(() {
      _timer = workSeconds;
      _timerStatus = TimerStatus.stopped;
      print("[=>]" + _timerStatus.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
      ElevatedButton(
        onPressed: () {},
        child: const Text(
          1 == 2 ? '계속하기' : '일시정지',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      const Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(
        onPressed: () {},
        child: const Text(
          '포기하기',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ];
    final List<Widget> _stoppedButtons = [
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: 1 == 2 ? Colors.green : Colors.blue,
        ),
        child: const Text(
          '시작하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('뽀모도로 타이머'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: 1 == 2 ? Colors.green : Colors.blue,
            ),
            child: const Center(
              child: Text(
                '00:00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 1 == 2
                ? const []
                : 1 == 2
                    ? _stoppedButtons
                    : _runningButtons,
          )
        ],
      ),
    );
  }
}
