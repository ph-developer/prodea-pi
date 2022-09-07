import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prodea/components/if.dart';
import 'package:prodea/dialogs/user_info_dialog.dart';
import 'package:prodea/extensions/date_time.dart';
import 'package:prodea/extensions/string.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/stores/donations_store.dart';
import 'package:prodea/stores/user_infos_store.dart';

class AvailableDonationsPage extends StatefulWidget {
  const AvailableDonationsPage({Key? key}) : super(key: key);

  @override
  State<AvailableDonationsPage> createState() => _AvailableDonationsPageState();
}

class _AvailableDonationsPageState extends State<AvailableDonationsPage> {
  final cityFilterController = TextEditingController();
  final donationsStore = i<DonationsStore>();
  final userInfosStore = i<UserInfosStore>();

  @override
  void dispose() {
    cityFilterController.dispose();
    super.dispose();
  }

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
            final donations = cityFilterController.text.isNotEmpty
                ? donationsStore.availableDonations
                    .where((donation) => userInfosStore
                        .getDonorById(donation.donorId!)
                        .city
                        .includes(cityFilterController.text))
                    .toList()
                : donationsStore.availableDonations;

            if (donationsStore.availableDonations.isEmpty) {
              return const Text(
                'Infelizmente não há doaçoes disponíveis no momento...',
              );
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
      controller: cityFilterController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.filter_alt_rounded),
        suffixIcon: cityFilterController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    cityFilterController.clear();
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
                  Observer(
                    builder: (context) {
                      final donor =
                          userInfosStore.getDonorById(donation.donorId!);

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
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      donationsStore.setDonationAsRequested(donation);
                    },
                    child: const Text('Solicitar Doação'),
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
