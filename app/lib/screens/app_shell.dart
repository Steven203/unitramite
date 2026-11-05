import 'package:flutter/material.dart';

import '../core/layout/breakpoints.dart';
import '../core/theme/app_colors.dart';
import '../widgets/layout/side_nav.dart';
import 'assistant_screen.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';

/// Contenedor principal. Con ventana ancha muestra una barra lateral; con
/// ventana angosta, la barra de navegación inferior. Ambas salen de la misma
/// lista de pestañas.
/// IndexedStack conserva el estado de cada pestaña al cambiar entre ellas.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const List<SideNavItem> _tabs = [
    SideNavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    SideNavItem(
      label: 'Alertas',
      icon: Icons.notifications_none,
      selectedIcon: Icons.notifications,
    ),
    SideNavItem(
      label: 'Perfil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  /// Conserva el estado de las pestañas si se cruza el ancho que cambia
  /// la barra lateral por la inferior (por ejemplo al redimensionar).
  final GlobalKey _bodyKey = GlobalKey();

  int _index = 0;

  void _select(int index) => setState(() => _index = index);

  void _openAssistant() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const AssistantScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeScreen(),
      const PlaceholderScreen(title: 'Alertas', icon: Icons.notifications_none),
      const PlaceholderScreen(title: 'Perfil', icon: Icons.person_outline),
    ];

    final body = IndexedStack(key: _bodyKey, index: _index, children: pages);

    if (Breakpoints.hasSidebar(context)) {
      return Scaffold(
        body: Row(
          children: [
            SideNav(
              tabs: _tabs,
              selectedIndex: _index,
              onTabSelected: _select,
              onAssistantPressed: _openAssistant,
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.brandBorder)),
        ),
        child: NavigationBar(
          height: 64,
          selectedIndex: _index,
          onDestinationSelected: _select,
          destinations: [
            for (final tab in _tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}
