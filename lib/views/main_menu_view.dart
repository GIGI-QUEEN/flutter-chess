import 'package:client/providers/user_provider.dart';
import 'package:client/views/create_lobby_view.dart';
import 'package:client/views/invites_view.dart';
import 'package:client/views/lobbies_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const LobbiesView(),
    const CreateLobbyView(),
    const InvitesView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0Xffffd452),
        elevation: 0,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: _currentIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.add),
            icon: Icon(Icons.add),
            label: 'new game',
          ),
          Consumer<UserProvider>(
            builder: (context, userModel, child) {
              return NavigationDestination(
                selectedIcon: const Icon(Icons.sports_esports),
                icon: Stack(children: <Widget>[
                  const Icon(Icons.sports_esports),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: userModel.invites.isNotEmpty
                        ? const Icon(Icons.brightness_1,
                            size: 8.0, color: Colors.redAccent)
                        : const Icon(Icons.brightness_1,
                            size: 0.0,
                            color: Colors
                                .redAccent), //Note: giving icon size 0.0 to make it invisible when no invites. Maybe there's a better way of doing this
                  )
                ]),
                label: 'invites',
              );
            },
          )
        ],
      ),
    );
  }
}

/* class _MainMenuViewState extends State<MainMenuView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const LobbiesView(),
    CreateLobbyView(),
    const LoginPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, model, child) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(
                title: model.user!.username,
              ),
              body: _screens[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add), label: 'new game'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.logout), label: 'log out'),
                ],
                backgroundColor: Color(0Xffffd452),
                elevation: 0.0,
              ),
            ));
  }
}
 */
