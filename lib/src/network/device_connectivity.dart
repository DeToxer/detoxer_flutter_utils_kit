import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

final class DeviceConnectivity {
  static final Uri _pingUrl = Uri.parse("https://www.google.com/generate_204");
  final Connectivity _connectivity = Connectivity();

  final BehaviorSubject<ConnectionResult> _subject = BehaviorSubject<ConnectionResult>();

  Timer? _timer;

  Stream<ConnectionResult> onConnectivityChanged() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
      final connected = connectivityResult.any((res) {
        return res == ConnectivityResult.mobile ||
            res == ConnectivityResult.wifi ||
            res == ConnectivityResult.ethernet ||
            res == ConnectivityResult.vpn ||
            res == ConnectivityResult.other;
      });

      if (!connected) {
        _subject.add(ConnectionResult.disconnected);
        return;
      }

      try {
        final pingRes = await http.get(_pingUrl);
        if (pingRes.statusCode != 204) {
          _subject.add(ConnectionResult.connectedNoInternet);
        } else {
          _subject.add(ConnectionResult.connectedWithInternet);
        }
      } catch (_) {
        _subject.add(ConnectionResult.connectedNoInternet);
      }
    });
    return _subject.stream.distinct();
  }

  Future<ConnectionResult> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    final connected = connectivityResult.any((res) {
      return res == ConnectivityResult.mobile ||
          res == ConnectivityResult.wifi ||
          res == ConnectivityResult.ethernet ||
          res == ConnectivityResult.vpn ||
          res == ConnectivityResult.other;
    });

    if (!connected) {
      return ConnectionResult.disconnected;
    }

    try {
      final pingRes = await http.get(_pingUrl);
      if (pingRes.statusCode != 204) {
        return ConnectionResult.connectedNoInternet;
      }
      return ConnectionResult.connectedWithInternet;
    } catch (_) {
      return ConnectionResult.connectedNoInternet;
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _subject.close();
  }
}

enum ConnectionResult {
  disconnected,
  connectedNoInternet,
  connectedWithInternet;
}
