// import 'package:clean_architecture_blog_app/core/common/cubits/app_user/app_user_cubit.dart';
// import 'package:clean_architecture_blog_app/core/theme/theme.dart';
// import 'package:clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:clean_architecture_blog_app/features/auth/presentation/pages/login_page.dart';
// import 'package:clean_architecture_blog_app/features/blog/presentation/bloc/blog_bloc.dart';
// import 'package:clean_architecture_blog_app/features/blog/presentation/pages/blog_page.dart';
// import 'package:clean_architecture_blog_app/features/init_dependencies.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initDependencies();
//   runApp(MultiBlocProvider(
//     providers: [
//       BlocProvider(
//         create: (_) => serviceLocator<AuthBloc>(),
//       ),
//       BlocProvider(
//         create: (_) => serviceLocator<AppUserCubit>(),
//       ),
//       BlocProvider(
//         create: (_) => serviceLocator<BlogBloc>(),
//       ),
//     ],
//     child: const MyApp(),
//   ));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AuthBloc>().add(AuthIsUserLoggedIn());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Blog App',
//       theme: AppTheme.darkThemeMode,
//       home: BlocSelector<AppUserCubit, AppUserState, bool>(
//         selector: (state) {
//           return state is AppUserLoggedIn;
//         },
//         builder: (context, isLoggedIn) {
//           return isLoggedIn ? const BlogPage() : const LoginPage();
//         },
//       ),
//     );
//   }
// }

import 'package:clean_architecture_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:clean_architecture_blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:clean_architecture_blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture_blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_blog_app/features/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeDeepLinkHandling();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog App',
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            return isLoggedIn ? const BlogPage() : const LoginPage();
          },
        ),
      ),
    );
  }

  void _initializeDeepLinkHandling() {
    // Set up a method channel to handle incoming deep links
    const MethodChannel channel = MethodChannel('app.channel.shared.data');
    channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'shared.data') {
        String? url = call.arguments['url'];
        if (url != null) {
          // Handle the deep link URL here
          _handleDeepLink(url);
        }
      }
    });
  }

  void _handleDeepLink(String url) {
    // Extract parameters from the URL and navigate to appropriate screen
    Uri uri = Uri.parse(url);
    if (uri.path == '/blog') {
      String? blogId = uri.queryParameters['blogId'];
      if (blogId != null) {
        // Navigate to the blog viewer page with the extracted blog ID
        // For example:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlogViewerPage(blogId: blogId)),
        );
      }
    }
  }
}
