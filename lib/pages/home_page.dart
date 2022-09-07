import 'package:flutter/material.dart';
import 'package:prodea/pages/home/my_donations_page.dart';
import 'package:prodea/pages/home/requested_donations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageInfos = [
    PageInfo(
      page: const Center(child: Text('Doar')),
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
      page: const Center(child: Text('Doações Disponíveis')),
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
    return Scaffold(
      body: pageInfos[currentPageIndex].page,
      appBar: AppBar(
        leading: Icon(pageInfos[currentPageIndex].icon),
        title: Text(pageInfos[currentPageIndex].title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_rounded),
          ),
          IconButton(
            onPressed: () {},
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
