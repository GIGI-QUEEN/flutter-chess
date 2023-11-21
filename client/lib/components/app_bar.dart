import 'package:client/main.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/services/data_base_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  CustomAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  final DataBaseService _dataBaseService = DataBaseService();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userModel, child) => AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  _dataBaseService.removeUserFromDB(userModel.user!);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } catch (e) {
                  throw Exception(e);
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
