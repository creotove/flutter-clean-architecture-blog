// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:clean_architecture_blog_app/core/error/exceptions.dart';
import 'package:clean_architecture_blog_app/features/blog/data/models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage({
    required BlogModel blog,
    required File image,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<BlogModel> getBlogById(String id);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({
    required this.supabaseClient,
  });

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage({
    required BlogModel blog,
    required File image,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map((blog) => BlogModel.fromJson(blog)
              .copyWith(posterName: blog['profiles']['name']))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> getBlogById(String id) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)')
          .eq('id', id)
          .single();
      return BlogModel.fromJson(blogData)
          .copyWith(posterName: blogData['profiles']['name']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
