import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/extensions/string.dart';
import '../../../injector.dart';
import '../stores/cities_store.dart';

Future<void> showCitySelectDialog(
  BuildContext context, {
  void Function(String)? onSelect,
}) async {
  await showDialog(
    context: context,
    builder: (_) => CitySelectDialog(onSelect: onSelect),
  );
}

class CitySelectDialog extends StatefulWidget {
  final void Function(String)? onSelect;

  const CitySelectDialog({this.onSelect, Key? key}) : super(key: key);

  @override
  State<CitySelectDialog> createState() => _CitySelectDialogState();
}

class _CitySelectDialogState extends State<CitySelectDialog> {
  final CitiesStore _citiesStore = inject();
  final _cityFilterController = TextEditingController();

  @override
  void dispose() {
    _cityFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecionar cidade'),
          const SizedBox(height: 8),
          _buildFilterField(),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Observer(
          builder: (_) {
            final cities = _cityFilterController.text.isNotEmpty
                ? _citiesStore.cities
                    .where(
                      (city) => city.includes(_cityFilterController.text),
                    )
                    .toList()
                : _citiesStore.cities;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: cities.length,
              itemBuilder: (_, index) {
                final city = cities[index];
                return ListTile(
                  title: Text(city),
                  onTap: () {
                    widget.onSelect?.call(city);
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Voltar'),
        ),
        TextButton(
          onPressed: () {
            widget.onSelect?.call('');
            Navigator.of(context).pop();
          },
          child: const Text('Limpar'),
        ),
      ],
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
        hintText: 'Filtrar cidades...',
      ),
    );
  }
}
