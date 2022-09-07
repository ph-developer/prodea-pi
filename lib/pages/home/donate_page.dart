import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prodea/extensions/input_formatters.dart';
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
  String description = '';
  File? image;
  String? beneficiaryId;
  String expiration = '';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descrição',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              description = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Descreva as condições do produto que será doado...',
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final file = await photoService.pickFromCamera();

                  if (file != null) {
                    setState(() {
                      image = file;
                    });
                  }
                },
                child: const Text('Tirar Foto'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final file = await photoService.pickFromGallery();

                  if (file != null) {
                    setState(() {
                      image = file;
                    });
                  }
                },
                child: const Text('Escolher da Galeria'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        image != null
            ? Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: FileImage(image!),
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
                            setState(() {
                              image = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Text('Nenhuma foto selecionada...'),
      ],
    );
  }

  Widget _buildBeneficiaryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doar para uma entidade específica? Caso não seja selecionada nenhuma entidade específica, a doação ficará disponível para qualquer entidade cadastrada na plataforma.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Observer(
          builder: (context) {
            return DropdownButton<String?>(
              items: [
                const DropdownMenuItem(value: null, child: Text('Não')),
                ...userInfosStore.beneficiaries.map(
                  (userInfo) => DropdownMenuItem(
                    value: userInfo.id,
                    child: Text(userInfo.name),
                  ),
                ),
              ],
              value: beneficiaryId,
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  beneficiaryId = value;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildExpirationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prazo de validade da doação',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              expiration = value;
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            dateMaskInputFormatter,
          ],
        ),
      ],
    );
  }

  SizedBox _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          donationStore.postDonation(
            description,
            image,
            beneficiaryId,
            expiration,
          );
        },
        child: const Text('Postar Doação'),
      ),
    );
  }
}
