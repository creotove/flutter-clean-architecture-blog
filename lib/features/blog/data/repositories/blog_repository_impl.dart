import 'dart:io';
import 'package:clean_architecture_blog_app/core/error/exceptions.dart';
import 'package:clean_architecture_blog_app/core/error/failures.dart';
import 'package:clean_architecture_blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:clean_architecture_blog_app/features/blog/data/models/blog_model.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoriesImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoriesImpl({required this.blogRemoteDataSource});
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blog = BlogModel(
        id: const Uuid().v1(),
        imageUrl: '',
        title: title,
        content: content,
        posterId: posterId,
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final uploadedImageUrl = await blogRemoteDataSource.uploadImage(
        blog: blog,
        image: image,
      );
      blog = blog.copyWith(imageUrl: uploadedImageUrl);
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blog);
      return Right(uploadedBlog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
