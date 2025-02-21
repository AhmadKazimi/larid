import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larid/core/theme/app_theme.dart';
import 'package:larid/core/l10n/app_localizations.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.onClear,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          style: GoogleFonts.notoSansArabic(
            fontSize: 16,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).searchForClient,
            hintStyle: GoogleFonts.notoSansArabic(
              fontSize: 16,
              color: Colors.grey,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppColors.primary,
              ),
              onPressed: () {
                controller.clear();
                if (onClear != null) onClear!();
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: onSearch,
        ),
      ),
    );
  }
}
