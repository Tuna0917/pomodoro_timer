import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

enum TimerStatus { running, paused, stopped, resting }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const workSeconds = 25 * 60;
  static const restSeconds = 5 * 60;

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

  String secondsToString(int seconds) {
    return sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
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
      print("[=>]$_timerStatus");
      runTimer();
    });
  }

  void rest() {
    setState(() {
      _timer = restSeconds;
      _timerStatus = TimerStatus.resting;
      print("[=>]$_timerStatus");
    });
  }

  void pause() {
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
      print("[=>]$_timerStatus");
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
      ElevatedButton(
        onPressed: _timerStatus == TimerStatus.paused ? resume : pause,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _timerStatus == TimerStatus.paused ? Colors.green : Colors.grey,
        ),
        child: Text(
          _timerStatus == TimerStatus.paused ? '계속하기' : '일시정지',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      const Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(
        onPressed: stop,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text(
          '포기하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ];
    final List<Widget> _stoppedButtons = [
      ElevatedButton(
        onPressed: run,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _timerStatus == TimerStatus.resting ? Colors.green : Colors.blue,
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _timerStatus == TimerStatus.resting
                  ? Colors.green
                  : Colors.blue,
            ),
            child: Center(
              child: Text(
                secondsToString(_timer),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _timerStatus == TimerStatus.resting
                ? const [Padding(padding: EdgeInsets.all(20))]
                : _timerStatus == TimerStatus.stopped
                    ? _stoppedButtons
                    : _runningButtons,
          )
        ],
      ),
    );
  }
}
