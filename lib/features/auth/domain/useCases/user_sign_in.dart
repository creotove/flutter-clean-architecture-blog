import 'package:clean_architecture_blog_app/core/error/failures.dart';
import 'package:clean_architecture_blog_app/core/useCase/usecase.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:clean_architecture_blog_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignIn(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
