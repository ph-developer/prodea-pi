import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.person_rounded),
            SizedBox(width: 12),
            Text('Meu Perfil'),
          ],
        ),
      ),
      body: const Center(
        child: Text('profile'),
      ),
    );
  }
}
