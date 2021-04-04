import 'dart:async';
import 'dart:isolate';

class BackgroundService {
  Isolate _isolate;
  Timer _timer;

  Future<ReceivePort> startIsolate() async {
    stopIsolete();
    ReceivePort receivePort = new ReceivePort();
    _isolate = await Isolate.spawn(
      _accionIsolate,
      {
        "sendPort": receivePort.sendPort,
      },
    );

    return receivePort;
  }

  void stopIsolete() {
    if (_isolate != null) {
      _isolate.kill(priority: Isolate.immediate);
      if (_timer != null) {
        _timer.cancel();
      }
    }
  }

  void _accionIsolate(Map<String, dynamic> data) {
    SendPort sendPort = data["sendPort"];
    int cont = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      cont++;
      print("count: $cont");
      sendPort.send({"timer": cont});
    });
  }
}
