import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/components/if.dart';
import 'package:prodea/dialogs/user_info_dialog.dart';
import 'package:prodea/extensions/date_time.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/models/dtos/donation_dto.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/stores/donations_store.dart';
import 'package:prodea/stores/donors_store.dart';

class RequestedDonationsPage extends StatefulWidget {
  const RequestedDonationsPage({Key? key}) : super(key: key);

  @override
  State<RequestedDonationsPage> createState() => _RequestedDonationsPageState();
}

class _RequestedDonationsPageState extends State<RequestedDonationsPage> {
  String cityFilter = '';
  final donationsStore = i<DonationsStore>();
  final donorsStore = i<DonorsStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: donationsStore.init,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (context) {
            final donations = donationsStore.requestedDonations;

            if (donations.isEmpty) {
              return const Text('No momento não há doaçoes solicitadas...');
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        // TODO
                        cityFilter = value;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.filter_alt_rounded),
                      hintText: 'Filtrar por cidade...',
                    ),
                  ),
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

  Widget _buildDonationCard(Donation donation) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          If(
            condition: () => donation.photoUrl != null,
            child: FutureBuilder(
              future: donationsStore.getDonationPhotoURL(donation),
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
                if (donation.donorId != null)
                  ScopedBuilder(
                    store: donorsStore,
                    onState: (context, List<UserInfo> state) {
                      final donor = donorsStore.getDonorById(donation.donorId!);

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
                    child: OutlinedButton(
                      onPressed: () {
                        donationsStore.setDonationAsDelivered(donation);
                      },
                      child: const Text('Marcar como Recebida'),
                    ),
                  ),
                if (donation.cancellation == null &&
                    !donation.isDelivered &&
                    !donation.isExpired)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        donationsStore.setDonationAsUnrequested(donation);
                      },
                      child: const Text('Cancelar Solicitação'),
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
