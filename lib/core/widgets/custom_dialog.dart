import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;
  final bool barrierDismissible;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.all(16),
      title: Text(
        title,
        style: GoogleFonts.notoSansArabic(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.light 
              ? AppColors.textColor
              : Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: GoogleFonts.notoSansArabic(
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.light 
              ? AppColors.textColor
              : Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: actions.map((action) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: action,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required List<Widget> actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CustomDialog(
      title: title,
      content: content,
      actions: actions,
      barrierDismissible: barrierDismissible,
    ),
  );
}
