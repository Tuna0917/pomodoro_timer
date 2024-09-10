import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
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
