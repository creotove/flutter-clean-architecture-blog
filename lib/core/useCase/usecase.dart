import 'package:clean_architecture_blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}

class ParamsId {
  final String id;
  ParamsId(this.id);
}
