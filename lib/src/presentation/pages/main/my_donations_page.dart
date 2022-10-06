import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/extensions/date_time.dart';
import '../../../../injector.dart';
import '../../../domain/dtos/donation_dto.dart';
import '../../../domain/entities/donation.dart';
import '../../dialogs/cancel_reason_dialog.dart';
import '../../dialogs/user_info_dialog.dart';
import '../../stores/donations_store.dart';
import '../../stores/users_store.dart';
import '../../widgets/app_bar/main_app_bar.dart';
import '../../widgets/button/connection_outlined_button.dart';
import '../../widgets/layout/layout_breakpoint.dart';

class MyDonationsPage extends StatefulWidget {
  const MyDonationsPage({Key? key}) : super(key: key);

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  final DonationsStore _donationsStore = inject();
  final UsersStore _usersStore = inject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        icon: const Icon(Icons.thumb_up_alt_rounded),
        title: 'Minhas Doações',
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
              final donations = _donationsStore.myDonations;

              if (donations.isEmpty) {
                return const Text('No momento não há doaçoes efetuadas...');
              }

              return ListView.builder(
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation = donations[index];
                  return LayoutBreakpoint(
                    xs: _buildMobileDonationCard(donation),
                    md: _buildWebDonationCard(donation),
                  );
                },
              );
            },
          ),
        ),
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
          if (donation.beneficiaryId != null)
            Observer(
              builder: (context) {
                final beneficiary =
                    _usersStore.getBeneficiaryById(donation.beneficiaryId!);

                return Row(
                  children: [
                    Text("Destino: ${beneficiary.name} "),
                    InkWell(
                      child: const Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                      ),
                      onTap: () => showUserDialog(context, user: beneficiary),
                    ),
                  ],
                );
              },
            ),
          Text("Situação: ${donation.status}"),
          const SizedBox(height: 8),
          if (donation.cancellation == null &&
              !donation.isDelivered &&
              !donation.isExpired &&
              donation.beneficiaryId != null)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ConnectionOutlinedButton(
                  onPressed: () =>
                      _donationsStore.setDonationAsDelivered(donation),
                  child: const Text('Marcar como Entregue'),
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
                  onPressed: () => showCancelReasonDialog(
                    context,
                    onOk: (reason) =>
                        _donationsStore.setDonationAsCanceled(donation, reason),
                  ),
                  child: const Text('Cancelar Doação'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
