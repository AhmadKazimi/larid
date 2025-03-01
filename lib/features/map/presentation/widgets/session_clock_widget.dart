import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

class SessionClockWidget extends StatefulWidget {
  final DateTime? sessionStartTime;
  final bool isSessionActive;

  const SessionClockWidget({
    super.key,
    this.sessionStartTime,
    required this.isSessionActive,
  });

  @override
  State<SessionClockWidget> createState() => _SessionClockWidgetState();
}

class _SessionClockWidgetState extends State<SessionClockWidget> {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _startTimer();
  }

  @override
  void didUpdateWidget(SessionClockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sessionStartTime != oldWidget.sessionStartTime ||
        widget.isSessionActive != oldWidget.isSessionActive) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.isSessionActive && widget.sessionStartTime != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _elapsedTime = DateTime.now().difference(widget.sessionStartTime!);
            _now = DateTime.now();
          });
        }
      });
    } else {
      setState(() {
        _elapsedTime = Duration.zero;
        _now = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations.of(context);
    final timeFormat = DateFormat('HH:mm:ss');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isSessionActive ? AppColors.primary : AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "عدد ساعات العمل",
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                if (widget.isSessionActive && widget.sessionStartTime != null)
                  Text(
                    _formatDuration(_elapsedTime),
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                else
                  Text(
                    timeFormat.format(_now),
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
