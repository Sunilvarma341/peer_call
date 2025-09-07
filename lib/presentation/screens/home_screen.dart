import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_call/core/app_colors.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/models/user_model.dart';
import 'package:peer_call/presentation/blocs/dash_board/dash_board_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    final ls = context.read<LocalStorage>();

    WidgetsBinding.instance.addPostFrameCallback((a) async {
      user = await ls.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<AppColors>();
    final ls = context.read<LocalStorage>();
    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        final filterList = state.allUsersList
            .where((e) => e.uid != (user?.uid ?? ''))
            .toList();
        print("${user?.uid}");
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: Text("Users list", style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, i) {
                      final UserModel data = filterList[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                          tileColor: c.cardShadow,
                          title: Text(
                            data.displayName.toString(),
                            style: TextStyle(color: c.black),
                          ),
                          leading: Text(
                            data.email.toString(),
                            style: TextStyle(color: c.black),
                          ),
                          onTap: () {},
                          enabled: false,
                          trailing: SizedBox(
                            height: 25,
                            child: FilledButton.tonal(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  c.primary,
                                ),
                              ),
                              onPressed: () {
                                print("PRESSED CALL");
                                context.push(
                                  PAGE.callScreen.path,
                                  extra: {'uid': user?.uid ?? ""},
                                );
                              },
                              child: Text(
                                "Call",
                                style: TextStyle(color: c.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
