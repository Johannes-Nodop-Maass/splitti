import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitti/state/receipts_cubit.dart';

class GlobalProviders extends StatelessWidget {
  const GlobalProviders({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptsCubit>(
      create: (_) => ReceiptsCubit(),
      child: child,
    );
  }
}
