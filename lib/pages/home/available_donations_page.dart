import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:prodea/dialogs/user_info_dialog.dart';
import 'package:prodea/extensions/date_time.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/models/donation.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/stores/available_donations_store.dart';
import 'package:prodea/stores/donors_store.dart';

class AvailableDonationsPage extends StatefulWidget {
  const AvailableDonationsPage({Key? key}) : super(key: key);

  @override
  State<AvailableDonationsPage> createState() => _AvailableDonationsPageState();
}

class _AvailableDonationsPageState extends State<AvailableDonationsPage> {
  String cityFilter = '';
  final availableDonationsStore = i<AvailableDonationsStore>();
  final donorsStore = i<DonorsStore>();

  @override
  void initState() {
    super.initState();
    availableDonationsStore.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: availableDonationsStore.fetchData,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ScopedBuilder(
          store: availableDonationsStore,
          onLoading: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          onState: (context, List<Donation> state) {
            if (state.isEmpty) {
              return const Text(
                'Infelizmente não há doaçoes disponíveis no momento...',
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        // TODO
                        cityFilter = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.filter_alt_rounded),
                      hintText: 'Filtrar por cidade...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final donation = state[index];
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
          FutureBuilder(
            future: availableDonationsStore.getDonationPhotoURL(donation),
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
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO
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
