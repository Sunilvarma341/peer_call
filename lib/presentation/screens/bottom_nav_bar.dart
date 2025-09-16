import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_call/core/app_colors.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/models/user_model.dart';
import 'package:peer_call/data/repositories/dashboard_repo.dart';
import 'package:peer_call/data/repositories/signaling_repo.dart';
import 'package:peer_call/presentation/blocs/dash_board/dash_board_export.dart';
import 'package:peer_call/presentation/screens/home_screen.dart';
import 'package:peer_call/presentation/screens/profile/profile_screen.dart';
import 'package:peer_call/presentation/widgets/p_scaffold.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  UserModel? user;
  late DashBoardBloc bloc;
  List<Widget> pages = [
    HomeScreen(),
    Center(child: Text('Search Screen')),
    ProfileScreen(),
  ];
  List<BottomNavigationBarItem> navItems(AppColors c, int i) {
    final color1 = i == 0 ? c.primary : c.darkText;
    final color2 = i == 1 ? c.primary : c.darkText;
    final color3 = i == 2 ? c.primary : c.darkText;

    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: color1),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search, color: color2),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person, color: color3),
        label: 'Profile',
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    // final ls = context.read<LocalStorage>();
    // final repo = context.read<SignalingRepo>();
    bloc = context.read<DashBoardBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<AppColors>();
    context.read<AppNavigator>().isCallScreenOpen();
    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        return PScaffold(
          body: pages[state.currentIndex],
          bottomAppBar: BottomAppBar(
            elevation: 0,
            color: c.transparent,
            padding: const EdgeInsets.all(0),
            child: BottomNavigationBar(
              selectedItemColor: c.primary,
              unselectedItemColor: c.darkGray,
              elevation: 0,
              items: navItems(c, state.currentIndex),
              currentIndex: state.currentIndex,
              iconSize: 22,
              onTap: (index) {
                context.read<DashBoardBloc>().add(BottomNavIndexChanged(index));
              },
            ),
          ),
        );
      },
    );
  }
}
