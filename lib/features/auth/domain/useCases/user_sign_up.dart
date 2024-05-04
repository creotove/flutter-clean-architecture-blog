import 'package:clean_architecture_blog_app/core/error/failures.dart';
import 'package:clean_architecture_blog_app/core/useCase/usecase.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:clean_architecture_blog_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
