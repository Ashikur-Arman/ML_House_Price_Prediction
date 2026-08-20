import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding:
              const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary
                    .withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  AppTheme.darkText,
                ),
              ),
            ),
          ],
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.greyText,
            ),
          ),
        ],
      ],
    );
  }
}