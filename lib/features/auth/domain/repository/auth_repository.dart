import 'package:clean_architecture_blog_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:clean_architecture_blog_app/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> getCurrentUserData();
}
