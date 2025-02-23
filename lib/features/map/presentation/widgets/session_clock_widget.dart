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
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    final timeFormat = DateFormat('HH:mm:ss');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isSessionActive ? [
            Colors.green.withOpacity(0.2),
            Colors.green.withOpacity(0.1),
          ] : [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isSessionActive 
            ? Colors.green.withOpacity(0.3)
            : AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(_now),
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 14,
                    color: widget.isSessionActive ? Colors.green.shade700.withOpacity(0.8) : AppColors.textColor.withOpacity(0.8),
                  ),
                ),
                Text(
                  timeFormat.format(_now),
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.isSessionActive ? Colors.green.shade700 : AppColors.primary,
                  ),
                ),
              ],
            ),
            if (widget.isSessionActive && widget.sessionStartTime != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: widget.isSessionActive ? Colors.green.shade700 : AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDuration(_elapsedTime),
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.isSessionActive ? Colors.green.shade700 : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
