import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Barra superior para pantallas anchas.
/// En móvil se usa HomeAppBar.
class DesktopTopBar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.brandBorder)),
        ),
        child: Row(children: [const Flexible(child: _Breadcrumb())]),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppConstants.brandName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.brandDark,
          ),
        ),
        Icon(Icons.chevron_right, size: 16, color: AppColors.brandMuted),
        Flexible(
          child: Text(
            'Plataforma Institucional',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}
