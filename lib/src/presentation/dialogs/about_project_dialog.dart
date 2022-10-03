import 'package:flutter/material.dart';

Future<void> showAboutProjectDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => const AboutProjectDialog(),
  );
}

class AboutProjectDialog extends StatelessWidget {
  const AboutProjectDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quais são os objetivos do PRODEA?'),
      content: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: const [
              Text(
                'O PRODEA tem como seu principal objetivo facilitar a doação de '
                'alimento para entidades beneficentes, pois se por um lado '
                'existe uma grande demanda por alimentos, por outro há um grande '
                'desperdício por parte dos supermercados, restaurantes, feiras '
                'entre outros tipos de comércios alimentícios.',
              ),
              SizedBox(height: 12),
              Text(
                'Grande parte desses alimentos, que na sua quase totalidade '
                'acabam indo para o lixo, por não estarem com uma boa aparência, '
                'ou por apresentarem pequenos danos em sua embalagem, ainda '
                'estão próprios para o consumo humano e poderiam ser '
                'aproveitados pelas entidades assistenciais que possuem em seu '
                'quadro de funcionários profissionais capacitados para fazerem a '
                'coleta, separação e distribuição segura destes alimentos.',
              ),
              SizedBox(height: 12),
              Text(
                'Então surge a pergunta, por que esses alimentos não são doados '
                'a quem precisa? A resposta para essa pergunta é simples, dos '
                'comerciantes entrevistados muitos possuem um grande receio em '
                'doar, alguns por problemas anteriores ou por problemas que '
                'podem vir a ocorrer.',
              ),
              SizedBox(height: 12),
              Text(
                'O nosso objetivo é conscientizar esses comerciantes sobre a lei '
                'Nº 14.016 (nenhum dos comerciantes entrevistados tinham '
                'conhecimento da lei), mostrando que com o apoio da lei é '
                'possível ter um amparo judicial na doação de alimentos que '
                'ainda estão próprios para consumo, e como a doação desses '
                'alimentos pode vir a ajudar muitas pessoas que estão em estado '
                'de vulnerabilidade social.',
              ),
              SizedBox(height: 12),
              Text(
                'Além de páginas que visam conscientizar sobre a importância de '
                'doar, a aplicação web vai permitir que entidades sejam '
                'cadastradas, esse cadastro vai coletar informações importantes '
                'sobre a entidade, como formas de contato, onde está localizada, '
                'um redirecionamento direto para o website da própria entidade '
                '(caso tenha um), e uma sessão onde pode ser contado brevemente '
                'a sua história, o trabalho que é realizado, o publico alvo, '
                'entre outras informações que possam ser consideradas '
                'importantes.',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Voltar'),
        ),
      ],
    );
  }
}
