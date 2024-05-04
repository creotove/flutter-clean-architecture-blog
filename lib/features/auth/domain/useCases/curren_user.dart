import 'package:clean_architecture_blog_app/core/error/failures.dart';
import 'package:clean_architecture_blog_app/core/useCase/usecase.dart';
import 'package:clean_architecture_blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:clean_architecture_blog_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUserData();
  }
}
