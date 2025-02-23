import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        !isPrimary
            ? TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
            : ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );

    final textStyle = GoogleFonts.notoKufiArabic(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    final button =
        !isPrimary
            ? TextButton(
              onPressed: onPressed,
              style: style,
              child: Text(text, style: textStyle),
            )
            : ElevatedButton(
              onPressed: onPressed,
              style: style,
              child: Text(text, style: textStyle),
            );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}
