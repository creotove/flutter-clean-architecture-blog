import 'package:clean_architecture_blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_blog_app/core/secrets/app_secrets.dart';
import 'package:clean_architecture_blog_app/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:clean_architecture_blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/useCases/curren_user.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/useCases/user_sign_in.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/useCases/user_sign_up.dart';
import 'package:clean_architecture_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseURI,
    anonKey: AppSecrets.supabaseAnon,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton<AppUserCubit>(
    () => AppUserCubit(),
  );
}

void _initAuth() {
  serviceLocator
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
