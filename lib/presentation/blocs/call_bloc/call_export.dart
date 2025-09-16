import 'dart:async';
import 'dart:math';
import 'dart:developer' as l;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peer_call/core/app_navigator.dart';
import 'package:peer_call/data/repositories/signaling_repo.dart';
import 'package:peer_call/data/services/webrtc_service.dart';
import 'package:peer_call/presentation/widgets/app_snackbar.dart';
import 'package:uuid/uuid.dart';

part 'call_bloc.dart';
part  'call_event.dart'; 
part  'call_state.dart';