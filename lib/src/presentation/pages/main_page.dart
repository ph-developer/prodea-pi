import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../controllers/auth_controller.dart';
import '../stores/donations_store.dart';
import 'main/available_donations_page.dart';
import 'main/donate_page.dart';
import 'main/my_donations_page.dart';
import 'main/requested_donations_page.dart';
import 'main/denied_page.dart';
import 'main/waiting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthController _authController = Modular.get();
  final DonationsStore _donationsStore = Modular.get();
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int _currentPageIndex = 0;

  @override
  void initState() {
    _donationsStore.fetchDonations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          body: _buildBody(),
          bottomNavigationBar: _buildNavigationBar(),
        );
      },
    );
  }

  Widget? _buildBody() {
    if (!_authController.isLoggedIn) return null;

    if (!_authController.isAuthorized) {
      if (_authController.isDenied) {
        return const DeniedPage();
      } else {
        return const WaitingPage();
      }
    }

    if (!_authController.isDonor && !_authController.isBeneficiary) {
      return null;
    }

    return PageView(
      controller: _pageController,
      children: [
        if (_authController.isDonor) const DonatePage(),
        if (_authController.isDonor) const MyDonationsPage(),
        if (_authController.isBeneficiary) const AvailableDonationsPage(),
        if (_authController.isBeneficiary) const RequestedDonationsPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
    );
  }

  Widget? _buildNavigationBar() {
    if (!_authController.isLoggedIn || !_authController.isAuthorized) {
      return null;
    }

    if (!_authController.isDonor && !_authController.isBeneficiary) {
      return null;
    }

    return NavigationBar(
      destinations: [
        if (_authController.isDonor)
          const NavigationDestination(
            icon: Icon(Icons.volunteer_activism_rounded),
            label: 'Doar',
          ),
        if (_authController.isDonor)
          const NavigationDestination(
            icon: Icon(Icons.thumb_up_alt_rounded),
            label: 'Minhas Doações',
          ),
        if (_authController.isBeneficiary)
          const NavigationDestination(
            icon: Icon(Icons.local_mall_rounded),
            label: 'Disponíveis',
          ),
        if (_authController.isBeneficiary)
          const NavigationDestination(
            icon: Icon(Icons.handshake_rounded),
            label: 'Solicitadas',
          ),
      ],
      selectedIndex: _currentPageIndex,
      onDestinationSelected: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
    );
  }
}
