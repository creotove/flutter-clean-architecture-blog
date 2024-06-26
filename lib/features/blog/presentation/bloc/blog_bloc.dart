import 'dart:io';
import 'package:clean_architecture_blog_app/core/useCase/usecase.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/usecases/get_blog_by_id.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final GetBlogById _getBlogById;
  BlogBloc(
      {required UploadBlog uploadBlog,
      required GetAllBlogs getAllBlogs,
      required GetBlogById getBlogById})
      : _getAllBlogs = getAllBlogs,
        _uploadBlog = uploadBlog,
        _getBlogById = getBlogById,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogFetchById>(_onFetchById);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
      image: event.image,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogFetchSuccess(r)),
    );
  }

  void _onFetchById(BlogFetchById event, Emitter<BlogState> emit) async {
    final res = await _getBlogById(ParamsId(event.id));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogFetchByIdSuccess(r)),
    );
  }
}
