import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/extensions/date_time.dart';
import '../../../domain/dtos/donation_dto.dart';
import '../../../domain/entities/donation.dart';
import '../../controllers/connection_state_controller.dart';
import '../../dialogs/cancel_reason_dialog.dart';
import '../../dialogs/user_info_dialog.dart';
import '../../stores/donations_store.dart';
import '../../stores/user_infos_store.dart';
import '../../widgets/if.dart';

class MyDonationsPage extends StatefulWidget {
  const MyDonationsPage({Key? key}) : super(key: key);

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  final ConnectionStateController _connectionStateController = Modular.get();
  final DonationsStore _donationsStore = Modular.get();
  final UserInfosStore _userInfosStore = Modular.get();

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
            final donations = _donationsStore.myDonations;

            if (donations.isEmpty) {
              return const Text('No momento não há doaçoes efetuadas...');
            }

            return ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return _buildDonationCard(donation);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonationCard(Donation donation) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          If(
            condition: donation.photoUrl != null,
            child: FutureBuilder(
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
                if (donation.beneficiaryId != null)
                  Observer(
                    builder: (context) {
                      final beneficiary = _userInfosStore
                          .getBeneficiaryById(donation.beneficiaryId!);

                      return Row(
                        children: [
                          Text("Destino: ${beneficiary.name} "),
                          InkWell(
                            child: const Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                            ),
                            onTap: () => showUserInfoDialog(
                              context,
                              userInfo: beneficiary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                Text("Situação: ${donation.status}"),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired &&
                    donation.beneficiaryId != null)
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
                        child: const Text('Marcar como Entregue'),
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
                                showCancelReasonDialog(context, onOk: (reason) {
                                  _donationsStore.setDonationAsCanceled(
                                      donation, reason);
                                });
                              }
                            : null,
                        child: const Text('Cancelar Doação'),
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
