import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/extensions/date_time.dart';
import '../../../../core/extensions/string.dart';
import '../../../domain/entities/donation.dart';
import '../../controllers/connection_state_controller.dart';
import '../../dialogs/user_info_dialog.dart';
import '../../stores/donations_store.dart';
import '../../stores/users_store.dart';
import '../../widgets/main_app_bar.dart';

class AvailableDonationsPage extends StatefulWidget {
  const AvailableDonationsPage({Key? key}) : super(key: key);

  @override
  State<AvailableDonationsPage> createState() => _AvailableDonationsPageState();
}

class _AvailableDonationsPageState extends State<AvailableDonationsPage> {
  final ConnectionStateController _connectionStateController = Modular.get();
  final DonationsStore _donationsStore = Modular.get();
  final UsersStore _usersStore = Modular.get();
  final _cityFilterController = TextEditingController();

  @override
  void initState() {
    _donationsStore.init();
    super.initState();
  }

  @override
  void dispose() {
    _cityFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        icon: Icons.local_mall_rounded,
        title: 'Doações Disponíveis',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _donationsStore.init,
        child: const Icon(Icons.refresh_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (context) {
            final donations = _cityFilterController.text.isNotEmpty
                ? _donationsStore.availableDonations
                    .where((donation) => _usersStore
                        .getDonorById(donation.donorId!)
                        .city
                        .includes(_cityFilterController.text))
                    .toList()
                : _donationsStore.availableDonations;

            if (_donationsStore.availableDonations.isEmpty) {
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
                                onTap: () => showUserDialog(
                                  context,
                                  user: donor,
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
                  child: Observer(
                    builder: (_) => OutlinedButton(
                      onPressed: _connectionStateController.isConnected
                          ? () {
                              _donationsStore.setDonationAsRequested(donation);
                            }
                          : null,
                      child: const Text('Solicitar Doação'),
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
