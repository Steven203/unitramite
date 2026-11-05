import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/adaptive_grid.dart';

class _Step {
  const _Step(this.color, this.onColor, this.title, this.subtitle);

  final Color color;
  final Color onColor;
  final String title;
  final String subtitle;
}

// Texto oscuro sobre amarillo y lima: el blanco no tiene contraste suficiente.
const List<_Step> _steps = [
  _Step(AppColors.primary, Colors.white, 'Encuentra',
      'Busca el trámite que necesitas'),
  _Step(AppColors.brandYellow, AppColors.brandDark, 'Comprende',
      'Revisa requisitos y costos oficiales'),
  _Step(AppColors.brandLime, AppColors.brandDark, 'Consulta',
      'Sigue el flujo guiado con apoyo IA'),
  _Step(AppColors.brandPurple, Colors.white, 'Verifica',
      'Accede a los enlaces oficiales Udenar'),
];

/// Los 4 pasos. Se adapta solo: lista vertical en espacios angostos y
/// 4 tarjetas en fila cuando hay ancho suficiente.
/// Si [onStepTap] es null los pasos son solo informativos y no muestran flecha.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key, this.onStepTap});

  final ValueChanged<int>? onStepTap;

  /// Ancho disponible desde el cual los pasos pasan a ir en fila.
  static const double _rowThreshold = 840;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Cómo funciona?', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth >= _rowThreshold
                ? _StepsRow(onStepTap: onStepTap)
                : _StepsList(onStepTap: onStepTap);
          },
        ),
      ],
    );
  }
}

class _StepsList extends StatelessWidget {
  const _StepsList({this.onStepTap});

  final ValueChanged<int>? onStepTap;

  @override
  Widget build(BuildContext context) {
    final onTap = onStepTap;

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.brandBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.brandBorder),
            _StepTile(
              number: i + 1,
              step: _steps[i],
              onTap: onTap == null ? null : () => onTap(i + 1),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepsRow extends StatelessWidget {
  const _StepsRow({this.onStepTap});

  final ValueChanged<int>? onStepTap;

  @override
  Widget build(BuildContext context) {
    final onTap = onStepTap;

    return AdaptiveGrid(
      columns: _steps.length,
      children: [
        for (var i = 0; i < _steps.length; i++)
          _StepCard(
            number: i + 1,
            step: _steps[i],
            onTap: onTap == null ? null : () => onTap(i + 1),
          ),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.step, this.onTap});

  final int number;
  final _Step step;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _NumberBadge(number: number, step: step, radius: 14),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandDark,
                    ),
                  ),
                  Text(
                    step.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.brandMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, size: 18, color: AppColors.brandMuted),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.step, this.onTap});

  final int number;
  final _Step step;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.brandBorder),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NumberBadge(number: number, step: step, radius: 18),
                  if (onTap != null)
                    const Icon(Icons.chevron_right, size: 20, color: AppColors.brandMuted),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppColors.brandMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({
    required this.number,
    required this.step,
    required this.radius,
  });

  final int number;
  final _Step step;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: step.color,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: radius >= 18 ? 15 : 13,
          fontWeight: FontWeight.w700,
          color: step.onColor,
        ),
      ),
    );
  }
}
