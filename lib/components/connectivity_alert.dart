import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdenis/bloc/connectivity/connectivity_bloc.dart';
import 'package:vdenis/bloc/connectivity/connectivity_state.dart';
import 'package:vdenis/helpers/snackbar_manager.dart';

class ConnectivityAlert extends StatelessWidget {
  const ConnectivityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) {
        return (previous is ConnectivityConnected &&
                current is ConnectivityDisconnected) ||
            (previous is ConnectivityDisconnected &&
                current is ConnectivityConnected);
      },
      listener: (context, state) {
        final SnackBarManager snackBarManager = SnackBarManager();
        if (state is ConnectivityDisconnected) {
          snackBarManager.setConnectivitySnackBarShowing(true);
        } else if (state is ConnectivityConnected) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          snackBarManager.setConnectivitySnackBarShowing(false);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
