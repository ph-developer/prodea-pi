import 'package:flutter/material.dart';
import 'package:prodea/controllers/auth_controller.dart';
import 'package:prodea/injection.dart';
import 'package:prodea/pages/home/available_donations_page.dart';
import 'package:prodea/pages/home/donate_page.dart';
import 'package:prodea/pages/home/my_donations_page.dart';
import 'package:prodea/pages/home/requested_donations_page.dart';
import 'package:prodea/services/contracts/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = i<AuthController>();
  final navigationService = i<INavigationService>();

  final _pageInfos = [
    PageInfo(
      page: const DonatePage(),
      icon: Icons.volunteer_activism_rounded,
      title: 'Doar',
      abbrTitle: 'Doar',
    ),
    PageInfo(
      page: const MyDonationsPage(),
      icon: Icons.thumb_up_alt_rounded,
      title: 'Minhas Doações',
      abbrTitle: 'Minhas Doações',
    ),
    PageInfo(
      page: const AvailableDonationsPage(),
      icon: Icons.local_mall_rounded,
      title: 'Doações Disponíveis',
      abbrTitle: 'Disponíveis',
    ),
    PageInfo(
      page: const RequestedDonationsPage(),
      icon: Icons.handshake_rounded,
      title: 'Doações Solicitadas',
      abbrTitle: 'Solicitadas',
    ),
  ];
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pageInfos = [];

    if (authController.isDonor) {
      pageInfos.add(_pageInfos[0]);
      pageInfos.add(_pageInfos[1]);
    }
    if (authController.isBeneficiary) {
      pageInfos.add(_pageInfos[2]);
      pageInfos.add(_pageInfos[3]);
    }

    return Scaffold(
      body: pageInfos[currentPageIndex].page,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(pageInfos[currentPageIndex].icon),
            const SizedBox(width: 12),
            Text(pageInfos[currentPageIndex].title),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => navigationService.navigate('/profile'),
            icon: const Icon(Icons.person_rounded),
          ),
          if (authController.isAdmin)
            IconButton(
              onPressed: () => navigationService.navigate('/admin'),
              icon: const Icon(Icons.admin_panel_settings_rounded),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: pageInfos
            .map((pageInfo) => NavigationDestination(
                  icon: Icon(pageInfo.icon),
                  label: pageInfo.abbrTitle,
                ))
            .toList(),
        selectedIndex: currentPageIndex,
        onDestinationSelected: (pageIndex) {
          setState(() {
            currentPageIndex = pageIndex;
          });
        },
      ),
    );
  }
}

class PageInfo {
  final Widget page;
  final IconData icon;
  final String title;
  final String abbrTitle;

  PageInfo({
    required this.page,
    required this.icon,
    required this.title,
    required this.abbrTitle,
  });
}
