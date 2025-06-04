import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/connectivity/connectivity_bloc.dart';
import 'package:vdenis/bloc/connectivity/connectivity_state.dart';
import 'package:vdenis/components/connectivity_alert.dart';
import 'package:vdenis/components/no_connectivity_screen.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityDisconnected) {
          return const NoConnectivityScreen();
        }

        return Stack(children: [child, const ConnectivityAlert()]);
      },
    );
  }
}
