import 'package:clean_architecture_blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:clean_architecture_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:clean_architecture_blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:clean_architecture_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:clean_architecture_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:clean_architecture_blog_app/features/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: BlogPage()),
    ),
    GoRoute(
      path: '/add-new-blog',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AddNewBlogPage()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
    ),
    GoRoute(
      path: '/blog/:blogId',
      pageBuilder: (context, state) {
        final blogId = state.pathParameters['blogId']!;
        return MaterialPage(child: BlogViewerPage(blogId: blogId));
      },
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => const MaterialPage(
        child: SignUpPage(),
      ),
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => serviceLocator<AuthBloc>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<AppUserCubit>(),
          ),
          BlocProvider(
            create: (_) => serviceLocator<BlogBloc>(),
          ),
        ],
        child: child!,
      ),
    );
  }
}
