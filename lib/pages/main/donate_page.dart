import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prodea/components/if.dart';
import 'package:prodea/controllers/connection_state_controller.dart';
import 'package:prodea/extensions/input_formatters.dart';
import 'package:prodea/extensions/string.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/services/contracts/photo_service.dart';
import 'package:prodea/stores/donation_store.dart';
import 'package:prodea/stores/user_infos_store.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final connectionStateController = i<ConnectionStateController>();
  final userInfosStore = i<UserInfosStore>();
  final donationStore = i<DonationStore>();
  final photoService = i<IPhotoService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      onChanged: (value) => donationStore.description = value,
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
                onPressed: () async {
                  final file = await photoService.pickFromCamera();
                  if (file != null) donationStore.image = file;
                },
                child: const Text('Tirar Foto'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final file = await photoService.pickFromGallery();
                  if (file != null) donationStore.image = file;
                },
                child: const Text('Escolher Foto da Galeria'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        If(
          condition: donationStore.image != null,
          elseChild: const Text('Nenhuma foto selecionada...'),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Observer(
              builder: (_) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: FileImage(donationStore.image!),
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
                            donationStore.image = null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
                ...userInfosStore.beneficiaries.map(
                  (userInfo) => DropdownMenuItem(
                    value: userInfo.id,
                    child: Text(userInfo.name),
                  ),
                ),
              ],
              value: donationStore.beneficiaryId,
              isExpanded: true,
              onChanged: (value) => donationStore.beneficiaryId = value,
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
        donationStore.expiration = value;
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
          final isLoading = donationStore.isLoading;
          final canSubmit = connectionStateController.isConnected &&
              donationStore.expiration.isNotEmpty &&
              donationStore.expiration.length == 10 &&
              donationStore.expiration.isAValidDate() &&
              donationStore.description.isNotEmpty;

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
            onPressed: canSubmit ? donationStore.postDonation : null,
            child: const Text('Postar Doação'),
          );
        },
      ),
    );
  }
}
