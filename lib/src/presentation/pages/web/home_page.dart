import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/navigation.dart';
import '../../dialogs/about_project_dialog.dart';
import '../../dialogs/donors_dialog.dart';
import '../../widgets/layout/layout_breakpoint.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prodeaLawUri = Uri.parse(
    'https://www.in.gov.br/web/dou/-/lei-n-14.016-de-23-de-junho-de-2020-263187111',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 12,
        ),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: _buildMainCard(),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBreakpoint(
                xs: Column(
                  children: [
                    _buildKnowLawCard(),
                    const SizedBox(height: 12),
                    _buildKnowProjectCard(),
                    const SizedBox(height: 12),
                    _buildParticipantsCard(),
                  ],
                ),
                lg: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 392,
                          minHeight: 290,
                        ),
                        child: _buildKnowLawCard(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 392,
                          minHeight: 290,
                        ),
                        child: _buildKnowProjectCard(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 392,
                          minHeight: 290,
                        ),
                        child: _buildParticipantsCard(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: const Divider(),
            ),
            const SizedBox(height: 12),
            const Text(
              '© 2022 - Projeto Integrador em Computação III (UNIVESP) '
              '- Turma 001 - Grupo 013',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Programa de Doação de Alimentos',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'O PRODEA é um programa que se baseia na Lei nº 14.016, de 23 '
              'de Junho de 2020, e tem como objetivo facilitar a doação de '
              'alimentos a entidades beneficentes.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => NavigationHelper.goTo('/login', replace: true),
              child: const Text('Acessar Plataforma'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowLawCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conheça a Lei',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text('Ainda não conhece a Lei nº 14.016/2020?'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => launchUrl(_prodeaLawUri),
              child: const Text('Saiba mais'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowProjectCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conheça o Projeto',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text('O que é o PRODEA?'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => showAboutProjectDialog(context),
              child: const Text('Saiba mais'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Participantes',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text('Conheça os participantes do projeto.'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => showDonorsDialog(context),
              child: const Text('Saiba mais'),
            ),
          ],
        ),
      ),
    );
  }
}
