import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/models/user_model.dart';
import 'package:peer_call/presentation/blocs/auth_bloc/auth_export.dart';
import 'package:peer_call/presentation/widgets/p_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) async {
      user = await context.read<LocalStorage>().getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();
        return PScaffold(
          isLoading: state is AuthLoading,
          appBar: AppBar(
            title: Text('Profile'),
            centerTitle: true,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              children: [
                // Profile image + edit button (stack)
                // Stack(
                //   alignment: Alignment.bottomRight,
                //   children: [
                //     CircleAvatar(
                //       radius: 60,
                //       backgroundImage: AssetImage(
                //         'assets/images/profile_placeholder.png',
                //       ),
                //     ),
                //     Positioned(
                //       bottom: 8,
                //       right: 8,
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Theme.of(context).primaryColor,
                //           shape: BoxShape.circle,
                //         ),
                //         child: IconButton(
                //           icon: Icon(Icons.edit, color: Colors.white, size: 20),
                //           onPressed: () {
                //             // Navigate to edit profile screen
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                Text(
                  'Sunil Varma',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? "",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('+91 90000 00000'),
                        ),
                        Divider(height: 24),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text('Hyderabad, India'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      bloc.add(SignOutRequested());
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
