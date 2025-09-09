import 'dart:async';

import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';


class CustomTimerWidget extends StatefulWidget {
  const CustomTimerWidget({super.key, required this.onResend, this.textColor});
  final Function onResend;
  final Color? textColor;

  @override
  State<CustomTimerWidget> createState() => _CustomTimerWidgetState();
}

class _CustomTimerWidgetState extends State<CustomTimerWidget> with AutomaticKeepAliveClientMixin{

  late Timer _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _remainingSeconds = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _handleResend() async{
    setState(() {
      _isLoading = true;
    });
    await widget.onResend();
    setState(() {
      _isLoading = false;
    });// Trigger resend logic from parent
    _startCountdown(); // Restart the timer
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading ? const Center(child: CircularProgressIndicator(),) : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_canResend)
          Text(
            '${language!.resendCodeIn} $_formattedTime',
            style: TextStyle(fontSize: 16, color: widget.textColor),
          )
        else
          TextButton(
            onPressed: _handleResend,
            child: Text(
    language!.resendCode,
              style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
            ),
          ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
