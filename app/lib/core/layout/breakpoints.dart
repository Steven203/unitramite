import 'package:flutter/widgets.dart';

/// Puntos de quiebre de la interfaz. Se decide por el ancho disponible,
/// no por el tipo de dispositivo.
class Breakpoints {
  Breakpoints._();

  /// Desde este ancho de contenido se usan 2 columnas.
  static const double medium = 600;

  /// Desde este ancho de contenido se usa la disposición de escritorio
  /// (3 columnas y buscador junto al asistente).
  static const double wide = 900;

  /// Desde este ancho de ventana aparece la barra lateral en lugar de la
  /// barra de navegación inferior.
  static const double sidebar = 1024;

  static bool hasSidebar(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= sidebar;
}
