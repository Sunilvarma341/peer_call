import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/data/local_storage/local_storage.dart';
import 'package:peer_call/data/models/user_model.dart';
import 'package:peer_call/data/repositories/auth_repo.dart';

part 'auth_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';
