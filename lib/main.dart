import 'package:clean_architecture_blog_app/core/secrets/app_secrets.dart';
import 'package:clean_architecture_blog_app/core/theme/theme.dart';
import 'package:clean_architecture_blog_app/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:clean_architecture_blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/useCases/user_sign_in.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/useCases/user_sign_up.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseURI,
    anonKey: AppSecrets.supabaseAnon,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthBloc(
          userSignUp: UserSignUp(
            AuthRepositoryImpl(
              AuthRemoteDataSourceImpl(supabase.client),
            ),
          ),
          userSignIn: UserSignIn(
            AuthRepositoryImpl(
              AuthRemoteDataSourceImpl(supabase.client),
            ),
          ),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
