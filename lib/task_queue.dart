import 'dart:async';

class TaskQueue {
  final List<Future Function()> _queue = [];
  bool _isProcessing = false;

  void enqueue(Future Function() request) {
    _queue.add(request);
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;

    _isProcessing = true;
    final currentTask = _queue.removeAt(0);
    await currentTask();
    _isProcessing = false;
    unawaited(_processQueue());
  }
}
