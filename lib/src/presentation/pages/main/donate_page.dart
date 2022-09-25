import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/extensions/string.dart';
import '../../../../core/input_formatters.dart';
import '../../controllers/connection_state_controller.dart';
import '../../stores/donation_store.dart';
import '../../stores/users_store.dart';
import '../../widgets/main_app_bar.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final ConnectionStateController _connectionStateController = Modular.get();
  final UsersStore _usersStore = Modular.get();
  final DonationStore _donationStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        icon: Icons.volunteer_activism_rounded,
        title: 'Doar',
      ),
      body: Padding(
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
                      image: DecorationImage(
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
          final canSubmit = _connectionStateController.isConnected &&
              _donationStore.expiration.isNotEmpty &&
              _donationStore.expiration.length == 10 &&
              _donationStore.expiration.isAValidDate() &&
              _donationStore.description.isNotEmpty;

          if (isLoading) {
            return const OutlinedButton(
              onPressed: null,
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }

          return OutlinedButton(
            onPressed: canSubmit ? _donationStore.postDonation : null,
            child: const Text('Postar Doação'),
          );
        },
      ),
    );
  }
}
