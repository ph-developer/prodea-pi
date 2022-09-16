import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/extensions/date_time.dart';
import '../../../../core/extensions/string.dart';
import '../../../domain/dtos/donation_dto.dart';
import '../../../domain/entities/donation.dart';
import '../../controllers/connection_state_controller.dart';
import '../../dialogs/user_info_dialog.dart';
import '../../stores/donations_store.dart';
import '../../stores/user_infos_store.dart';

class RequestedDonationsPage extends StatefulWidget {
  const RequestedDonationsPage({Key? key}) : super(key: key);

  @override
  State<RequestedDonationsPage> createState() => _RequestedDonationsPageState();
}

class _RequestedDonationsPageState extends State<RequestedDonationsPage> {
  final ConnectionStateController _connectionStateController = Modular.get();
  final DonationsStore _donationsStore = Modular.get();
  final UserInfosStore _userInfosStore = Modular.get();
  final _cityFilterController = TextEditingController();

  @override
  void dispose() {
    _cityFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _donationsStore.init,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (context) {
            final donations = _cityFilterController.text.isNotEmpty
                ? _donationsStore.requestedDonations
                    .where((donation) => _userInfosStore
                        .getDonorById(donation.donorId!)
                        .city
                        .includes(_cityFilterController.text))
                    .toList()
                : _donationsStore.requestedDonations;

            if (_donationsStore.requestedDonations.isEmpty) {
              return const Text('No momento não há doaçoes solicitadas...');
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildFilterField(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      final donation = donations[index];
                      return _buildDonationCard(donation);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterField() {
    return TextFormField(
      controller: _cityFilterController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.filter_alt_rounded),
        suffixIcon: _cityFilterController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _cityFilterController.clear();
                  });
                },
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        hintText: 'Filtrar por cidade...',
      ),
    );
  }

  Widget _buildDonationCard(Donation donation) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (donation.photoUrl != null)
            FutureBuilder(
              future: _donationsStore.getDonationPhotoURL(donation),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(
                    height: 215,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    height: 215,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(snapshot.data!),
                      ),
                    ),
                  );
                }
              },
            ),
          ListTile(
            title: Text(donation.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (donation.createdAt != null)
                  Text("Data da Doação: ${donation.createdAt!.toDateStr()}"),
                if (!donation.isDelivered)
                  Text("Validade: ${donation.expiration}"),
                if (donation.donorId != null)
                  Observer(
                    builder: (context) {
                      final donor =
                          _userInfosStore.getDonorById(donation.donorId!);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Doador: ${donor.name} "),
                              InkWell(
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                ),
                                onTap: () => showUserInfoDialog(
                                  context,
                                  userInfo: donor,
                                ),
                              ),
                            ],
                          ),
                          Text("Cidade: ${donor.city} "),
                        ],
                      );
                    },
                  ),
                Text("Situação: ${donation.status}"),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired)
                  SizedBox(
                    width: double.infinity,
                    child: Observer(
                      builder: (_) => OutlinedButton(
                        onPressed: _connectionStateController.isConnected
                            ? () {
                                _donationsStore
                                    .setDonationAsDelivered(donation);
                              }
                            : null,
                        child: const Text('Marcar como Recebida'),
                      ),
                    ),
                  ),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired)
                  SizedBox(
                    width: double.infinity,
                    child: Observer(
                      builder: (_) => OutlinedButton(
                        onPressed: _connectionStateController.isConnected
                            ? () {
                                _donationsStore
                                    .setDonationAsUnrequested(donation);
                              }
                            : null,
                        child: const Text('Cancelar Solicitação'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
