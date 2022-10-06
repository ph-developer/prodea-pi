import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/extensions/string.dart';
import '../../../../core/input_formatters.dart';
import '../../../../injector.dart';
import '../../stores/donation_store.dart';
import '../../stores/users_store.dart';
import '../../widgets/app_bar/main_app_bar.dart';
import '../../widgets/button/connection_outlined_button.dart';
import '../../widgets/button/loading_outlined_button.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final UsersStore _usersStore = inject();
  final DonationStore _donationStore = inject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        icon: const Icon(Icons.volunteer_activism_rounded),
        title: 'Doar',
      ),
      body: Center(
        heightFactor: 1,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescriptionField(),
                const SizedBox(height: 24),
                _buildPhotoField(),
                const SizedBox(height: 24),
                _buildBeneficiaryField(),
                const SizedBox(height: 24),
                _buildExpirationField(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      onChanged: (value) => _donationStore.description = value,
      decoration: const InputDecoration(
        labelText: 'Descrição',
        hintText: 'Descreva as condições do produto que será doado...',
      ),
    );
  }

  Widget _buildPhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _donationStore.pickImageFromGallery,
                  child: const Text('Escolher Arquivo de Foto'),
                ),
              ),
            ],
          ),
        if (!kIsWeb)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _donationStore.pickImageFromCamera,
                  child: const Text('Tirar Foto'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _donationStore.pickImageFromGallery,
                  child: const Text('Escolher Foto da Galeria'),
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        Observer(
          builder: (_) {
            if (_donationStore.image == null) {
              return const Text('Nenhuma foto selecionada...');
            }

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Observer(
                builder: (_) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: kIsWeb
                          ? DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(_donationStore.image!.path),
                            )
                          : DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: FileImage(_donationStore.image!),
                            ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _donationStore.image = null;
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBeneficiaryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Observer(
          builder: (context) {
            return DropdownButtonFormField<String?>(
              decoration: const InputDecoration(
                labelText: 'Doar para uma entidade específica?',
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Não'),
                ),
                ..._usersStore.beneficiaries.map(
                  (userInfo) => DropdownMenuItem(
                    value: userInfo.id,
                    child: Text(userInfo.name),
                  ),
                ),
              ],
              value: _donationStore.beneficiaryId,
              isExpanded: true,
              onChanged: (value) => _donationStore.beneficiaryId = value,
            );
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Caso não seja selecionada nenhuma entidade específica, a doação '
          'ficará disponível para qualquer entidade cadastrada na plataforma.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildExpirationField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Prazo de validade da doação',
      ),
      onChanged: (value) {
        _donationStore.expiration = value;
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        dateMaskInputFormatter,
      ],
    );
  }

  SizedBox _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Observer(
        builder: (_) {
          final isLoading = _donationStore.isLoading;
          final canSubmit = _donationStore.expiration.isNotEmpty &&
              _donationStore.expiration.length == 10 &&
              _donationStore.expiration.isAValidDate() &&
              _donationStore.description.isNotEmpty;

          if (isLoading) {
            return const LoadingOutlinedButton();
          }

          return ConnectionOutlinedButton(
            onPressed: canSubmit
                ? () => _donationStore.postDonation(
                      onSuccess: () {
                        context
                            .findAncestorWidgetOfExactType<PageView>()
                            ?.controller
                            .animateToPage(
                              1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                      },
                    )
                : null,
            child: const Text('Postar Doação'),
          );
        },
      ),
    );
  }
}
