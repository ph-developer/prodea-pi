import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/extensions/date_time.dart';
import '../../../../core/extensions/string.dart';
import '../../../domain/dtos/donation_dto.dart';
import '../../../domain/entities/donation.dart';
import '../../dialogs/user_info_dialog.dart';
import '../../stores/donations_store.dart';
import '../../stores/users_store.dart';
import '../../widgets/app_bar/main_app_bar.dart';
import '../../widgets/button/connection_outlined_button.dart';
import '../../widgets/layout/layout_breakpoint.dart';

class RequestedDonationsPage extends StatefulWidget {
  const RequestedDonationsPage({Key? key}) : super(key: key);

  @override
  State<RequestedDonationsPage> createState() => _RequestedDonationsPageState();
}

class _RequestedDonationsPageState extends State<RequestedDonationsPage> {
  final DonationsStore _donationsStore = Modular.get();
  final UsersStore _usersStore = Modular.get();
  final _cityFilterController = TextEditingController();

  @override
  void dispose() {
    _cityFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        icon: const Icon(Icons.handshake_rounded),
        title: 'Doações Solicitadas',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _donationsStore.fetchDonations,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(16),
          child: Observer(
            builder: (context) {
              final donations = _cityFilterController.text.isNotEmpty
                  ? _donationsStore.requestedDonations
                      .where((donation) => _usersStore
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
                        return LayoutBreakpoint(
                          xs: _buildMobileDonationCard(donation),
                          md: _buildWebDonationCard(donation),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
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

  Widget _buildMobileDonationCard(Donation donation) {
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
          _buildCardListTile(donation),
        ],
      ),
    );
  }

  Widget _buildWebDonationCard(Donation donation) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          if (donation.photoUrl != null)
            FutureBuilder(
              future: _donationsStore.getDonationPhotoURL(donation),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(
                    width: 325,
                    height: 250,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    width: 325,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(snapshot.data!),
                      ),
                    ),
                  );
                }
              },
            ),
          Expanded(
            child: _buildCardListTile(donation),
          ),
        ],
      ),
    );
  }

  Widget _buildCardListTile(Donation donation) {
    return ListTile(
      title: Text(donation.description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (donation.createdAt != null)
            Text("Data da Doação: ${donation.createdAt!.toDateStr()}"),
          if (!donation.isDelivered) Text("Validade: ${donation.expiration}"),
          if (donation.donorId != null)
            Observer(
              builder: (context) {
                final donor = _usersStore.getDonorById(donation.donorId!);

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
                          onTap: () => showUserDialog(context, user: donor),
                        ),
                      ],
                    ),
                    Text("Cidade: ${donor.city} "),
                  ],
                );
              },
            ),
          Text("Situação: ${donation.status}"),
          const SizedBox(height: 8),
          if (donation.cancellation == null &&
              !donation.isDelivered &&
              !donation.isExpired)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ConnectionOutlinedButton(
                  onPressed: () =>
                      _donationsStore.setDonationAsDelivered(donation),
                  child: const Text('Marcar como Recebida'),
                ),
              ),
            ),
          if (donation.cancellation == null &&
              !donation.isDelivered &&
              !donation.isExpired)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ConnectionOutlinedButton(
                  onPressed: () =>
                      _donationsStore.setDonationAsUnrequested(donation),
                  child: const Text('Cancelar Solicitação'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
