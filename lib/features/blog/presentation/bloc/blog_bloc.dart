import 'dart:io';
import 'package:clean_architecture_blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(
    this.uploadBlog,
  ) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await uploadBlog(UploadBlogParams(
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
      image: event.image,
    ));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogSuccess()),
    );
  }
}
