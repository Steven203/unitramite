import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class SideNavItem {
  const SideNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Barra lateral para pantallas anchas. Reemplaza a la barra inferior.
/// Además de las pestañas, incluye un acceso directo al asistente.
class SideNav extends StatelessWidget {
  const SideNav({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAssistantPressed,
  });

  final List<SideNavItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAssistantPressed;

  /// Posición del acceso al asistente dentro de la lista visible.
  static const int _assistantPosition = 2;

  @override
  Widget build(BuildContext context) {
    final entries = <Widget>[
      for (var i = 0; i < tabs.length; i++)
        _NavTile(
          label: tabs[i].label,
          icon: i == selectedIndex ? tabs[i].selectedIcon : tabs[i].icon,
          selected: i == selectedIndex,
          onTap: () => onTabSelected(i),
        ),
    ];
    entries.insert(
      _assistantPosition.clamp(0, entries.length),
      _NavTile(
        label: 'Asistente IA',
        icon: Icons.smart_toy_outlined,
        selected: false,
        onTap: onAssistantPressed,
      ),
    );

    return Container(
      width: 232,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDark.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(1, 0),
          ),
        ],
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Brand(),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Text(
                'NAVEGACIÓN',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.brandMuted,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (var i = 0; i < entries.length; i++) ...[
                    if (i > 0) const SizedBox(height: 4),
                    entries[i],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Reemplazar por Image.asset(...) cuando exista el logo oficial.
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 22,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.brandName,
                    style: GoogleFonts.robotoFlex(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      height: 1.1,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Text(
                    AppConstants.brandTagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: AppColors.brandMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : AppColors.brandMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? AppColors.primaryDark : Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
