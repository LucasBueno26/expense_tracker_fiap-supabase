import 'package:expense_tracker/pages/conta_cadastro_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/pages/meta_adicionarvalor_page.dart';
import 'package:expense_tracker/pages/meta_cadastro_page.dart';
import 'package:expense_tracker/pages/meta_detalhes_page.dart';
import 'package:expense_tracker/pages/registar_page.dart';
import 'package:expense_tracker/pages/splash_page.dart';
import 'package:expense_tracker/pages/transacao_cadastro_page.dart';
import 'package:expense_tracker/pages/transacao_detalhes_page.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://zkjibwwddkeuuxakqtvg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpramlid3dkZGtldXV4YWtxdHZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU5ODkyMzksImV4cCI6MjAxMTU2NTIzOX0.j0umCh6lW_xFIy9Hyy5ytGTDabB6tb_m1K1fvTAUx-I',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const HomePage(),
        "/splash": (context) => const SplashPage(),
        "/login": (context) => const LoginPage(),
        "/registrar": (context) => const RegistrarPage(),
        "/transacao-detalhes": (context) => const TransacaoDetalhesPage(),
        "/transacao-cadastro": (context) => const TransacaoCadastroPage(),
        "/conta-cadastro": (context) => const ContaCadastroPage(),
        "/meta-cadastro": (context) => const MetaCadastroPage(),
        "/meta-detalhes": (context) => const MetaDetalhesPage(),
        "/meta-adicionar": (context) => const MetaAdicionarPage(),
      },
      initialRoute: "/splash",
    );
  }
}
