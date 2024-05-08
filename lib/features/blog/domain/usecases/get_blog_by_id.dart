import 'package:clean_architecture_blog_app/core/error/failures.dart';
import 'package:clean_architecture_blog_app/core/useCase/usecase.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBlogById implements UseCase<Blog, ParamsId> {
  final BlogRepository blogRepository;
  GetBlogById(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(ParamsId params) async {
    return await blogRepository.getBlogById(params.id);
  }
}
