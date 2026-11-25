import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/store_cubit.dart';
import 'repositories/store_repository.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      StoreCubit(StoreRepository())..loadProducts(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // Pe web/desktop aplicatia ramane cat un ecran de telefon,
        // ca imaginile din Lab 2 sa nu fie intinse si neclare.
        builder: (context, child) => Container(
          color: const Color(0xFFEDEDED),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),

        title: 'GemStore',

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4E8E82),
          ),
        ),

        home: const HomePage(),
      ),
    );
  }
}