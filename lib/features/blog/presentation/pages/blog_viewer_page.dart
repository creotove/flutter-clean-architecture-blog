// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Import flutter services for Share
// import 'package:clean_architecture_blog_app/core/common/widgets/loader.dart';
// import 'package:clean_architecture_blog_app/core/secrets/app_secrets.dart';
// import 'package:clean_architecture_blog_app/core/theme/app_pallete.dart';
// import 'package:clean_architecture_blog_app/core/utils/calculate_reading_time.dart';
// import 'package:clean_architecture_blog_app/core/utils/format_date.dart';
// import 'package:clean_architecture_blog_app/features/blog/data/models/blog_model.dart';
// import 'package:clean_architecture_blog_app/features/blog/domain/entities/blog.dart';
// import 'package:dio/dio.dart';
// import 'package:share/share.dart';

// class BlogViewerPage extends StatelessWidget {
//   final String blogId; // Add a field for the blog ID
//   const BlogViewerPage({
//     Key? key,
//     required this.blogId,
//   }) : super(key: key);

//   Future<Blog> fetchBlog() async {
//     try {
//       // Fetching the blog data
//       final uri = '${AppSecrets.supabaseURI}/rest/v1/blogs?id=eq.$blogId';
//       final response = await Dio().get(
//         uri,
//         options: Options(
//           headers: {
//             'apikey': '${AppSecrets.supabaseAnon}',
//           },
//         ),
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to load blog');
//       }

//       // Extracting blog data
//       final blogData = response.data!.first;

//       // Extracting poster_id from blog data
//       final posterId = blogData['poster_id'];

//       // Fetching profile data using poster_id
//       final profileUri =
//           '${AppSecrets.supabaseURI}/rest/v1/profiles?id=eq.$posterId';
//       final profileResponse = await Dio().get(
//         profileUri,
//         options: Options(
//           headers: {
//             'apikey': '${AppSecrets.supabaseAnon}',
//           },
//         ),
//       );

//       if (profileResponse.statusCode != 200) {
//         throw Exception('Failed to load profile');
//       }
//       final username = profileResponse.data!.first['name'];
//       final blog = BlogModel.fromJson(blogData).copyWith(posterName: username);
//       return blog;
//     } catch (e) {
//       throw Exception('Failed to load blog');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               icon: Icon(Icons.share),
//               onPressed: () {
//                 print("share");
//                 fetchBlog().then((blog) {
//                   // Generate a unique URL for this blog post
//                   var blogUrl = 'myapp://blog?blogId=${blog.id}';

//                   // Share the blog title, content, and URL
//                   Share.share('${blog.title}\n\n\nRead more:\n $blogUrl');
//                 });
//               })
//         ],
//       ),
//       body: FutureBuilder<Blog>(
//         future: fetchBlog(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Loader();
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final blog = snapshot.data!;
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       blog.title,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'By ${blog.posterName}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         color: AppPallete.greyColor,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(blog.imageUrl),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       blog.content,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         height: 2,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import flutter services for Share
import 'package:clean_architecture_blog_app/core/common/widgets/loader.dart';
import 'package:clean_architecture_blog_app/core/secrets/app_secrets.dart';
import 'package:clean_architecture_blog_app/core/theme/app_pallete.dart';
import 'package:clean_architecture_blog_app/core/utils/calculate_reading_time.dart';
import 'package:clean_architecture_blog_app/core/utils/format_date.dart';
import 'package:clean_architecture_blog_app/features/blog/data/models/blog_model.dart';
import 'package:clean_architecture_blog_app/features/blog/domain/entities/blog.dart';
import 'package:dio/dio.dart';
import 'package:share/share.dart';
import 'dart:async';

class BlogViewerPage extends StatelessWidget {
  final String blogId; // Add a field for the blog ID
  const BlogViewerPage({
    Key? key,
    required this.blogId,
  }) : super(key: key);

  // Function to handle deep links
  Future<void> _handleDeepLink(String url) async {
    // Parse the URL and extract the blog ID
    Uri uri = Uri.parse(url);
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'blog') {
      String? blogId = uri.queryParameters['blogId'];
      if (blogId != null) {
        // Fetch the blog with the extracted blog ID and navigate to it
        Blog blog = await fetchBlog(blogId);
        if (blog != null) {
          // Navigate to the blog post page
          // You would implement your navigation logic here
          // For example:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => BlogViewerPage(blogId: blogId)),
          // );
        }
      }
    }
  }

  Future<Blog> fetchBlog(String blogId) async {
    try {
      // Fetching the blog data
      final uri = '${AppSecrets.supabaseURI}/rest/v1/blogs?id=eq.$blogId';
      final response = await Dio().get(
        uri,
        options: Options(
          headers: {
            'apikey': '${AppSecrets.supabaseAnon}',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load blog');
      }

      // Extracting blog data
      final blogData = response.data!.first;

      // Extracting poster_id from blog data
      final posterId = blogData['poster_id'];

      // Fetching profile data using poster_id
      final profileUri =
          '${AppSecrets.supabaseURI}/rest/v1/profiles?id=eq.$posterId';
      final profileResponse = await Dio().get(
        profileUri,
        options: Options(
          headers: {
            'apikey': '${AppSecrets.supabaseAnon}',
          },
        ),
      );

      if (profileResponse.statusCode != 200) {
        throw Exception('Failed to load profile');
      }
      final username = profileResponse.data!.first['name'];
      final blog = BlogModel.fromJson(blogData).copyWith(posterName: username);
      return blog;
    } catch (e) {
      throw Exception('Failed to load blog');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize deep link handling
    _initializeDeepLinkHandling();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                print("share");
                fetchBlog(blogId).then((blog) {
                  // Generate a unique URL for this blog post
                  var blogUrl = 'myapp://blog?blogId=${blog!.id}';

                  // Share the blog title, content, and URL
                  Share.share('${blog.title}\n\n\nRead more:\n $blogUrl');
                });
              })
        ],
      ),
      body: FutureBuilder<Blog>(
        future: fetchBlog(blogId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final blog = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'By ${blog.posterName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppPallete.greyColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(blog.imageUrl),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      blog.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 2,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Function to initialize deep link handling
  void _initializeDeepLinkHandling() {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also listen for updates to the `_url` stream and call `_handleDeepLink`
    // in the callback to handle incoming deep links
    try {
      // Attach a listener to the platform channel to get deep links
      // Note: You need to set up the platform channel in the native side of your app (e.g., AndroidManifest.xml for Android)
      MethodChannel('app.channel.shared.data')
          .setMethodCallHandler((MethodCall call) async {
        final String url = call.arguments;
        _handleDeepLink(url);
      });
    } on PlatformException {
      // Failed to initialize deep link handling
    }
  }
}
