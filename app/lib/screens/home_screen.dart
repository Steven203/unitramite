import 'package:flutter/material.dart';

import '../core/layout/breakpoints.dart';
import '../core/theme/app_text_styles.dart';
import '../data/sample_tramites.dart';
import '../widgets/common/adaptive_grid.dart';
import '../widgets/home/assistant_card.dart';
import '../widgets/home/desktop_top_bar.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/how_it_works_section.dart';
import '../widgets/home/search_hero_card.dart';
import '../widgets/home/tramite_card.dart';
import 'assistant_screen.dart';

/// Pantalla de inicio. Solo compone widgets; la lógica del chat sigue en
/// ChatProvider y AssistantScreen.
///
/// Se adapta al ancho disponible:
/// - compacto (< 600): una columna, como en el celular.
/// - medio (600 a 899): una columna con cuadrículas de 2 columnas.
/// - amplio (>= 900): buscador junto al asistente y cuadrículas de 3 columnas.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<QuickQuestion> _quickQuestions = [
    QuickQuestion(
      '¿Cómo tramitar certificado de notas?',
      Icons.chat_bubble_outline,
    ),
    QuickQuestion(
      '¿Cuándo vence el plazo de cancelación de materias?',
      Icons.schedule,
    ),
    QuickQuestion(
      '¿Cómo pago estampilla Pro-Udenar por PSE?',
      Icons.payments_outlined,
    ),
  ];

  void _openAssistant(BuildContext context, {String? question}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AssistantScreen(initialQuestion: question),
      ),
    );
  }

  void _search(BuildContext context, String query) =>
      _openAssistant(context, question: query);

  @override
  Widget build(BuildContext context) {
    final hasSidebar = Breakpoints.hasSidebar(context);

    return Scaffold(
      appBar: hasSidebar ? DesktopTopBar() : const HomeAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isCompact = width < Breakpoints.medium;
            final isWide = width >= Breakpoints.wide;
            final margin = isCompact ? 20.0 : 32.0;
            final columns = isWide ? 3 : (isCompact ? 1 : 2);
            final gap = isCompact ? 20.0 : 32.0;

            final intro = _intro(context, isWide: isWide);
            final recommended = _recommended(
              context,
              columns: columns,
              isCompact: isCompact,
            );
            const howItWorks = HowItWorksSection();

            // En compacto se conserva el orden del diseño móvil.
            final sections = <Widget>[
              intro,
              if (isCompact) ...[
                recommended,
                howItWorks,
              ] else ...[
                howItWorks,
                recommended,
              ],
            ];

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(margin, 16, margin, 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < sections.length; i++) ...[
                        if (i > 0) SizedBox(height: gap),
                        sections[i],
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Buscador + asistente: apilados, o lado a lado (8/4) en pantallas amplias.
  Widget _intro(BuildContext context, {required bool isWide}) {
    final hero = SearchHeroCard(onSearch: (query) => _search(context, query));
    final assistant = AssistantCard(
      questions: _quickQuestions,
      onQuestionTap: (question) => _openAssistant(context, question: question),
      onStartChat: () => _openAssistant(context),
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [hero, const SizedBox(height: 20), assistant],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 8, child: hero),
          const SizedBox(width: 24),
          Expanded(flex: 4, child: assistant),
        ],
      ),
    );
  }

  Widget _recommended(
    BuildContext context, {
    required int columns,
    required bool isCompact,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trámites recomendados',
              style: AppTextStyles.sectionTitle,
            ),
          ],
        ),
        SizedBox(height: isCompact ? 8 : 12),
        AdaptiveGrid(
          columns: columns,
          spacing: isCompact ? 10 : 16,
          children: [
            for (final tramite in sampleTramites)
              TramiteCard(
                tramite: tramite,
                onTap: () => _openAssistant(
                  context,
                  question: '¿Cómo hago el trámite "${tramite.title}"?',
                ),
              ),
          ],
        ),
      ],
    );
  }
}
