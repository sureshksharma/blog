import 'package:blogapp/screens/post_upload_screen.dart';
import 'package:blogapp/screens/widgets/posts.dart';
import 'package:blogapp/services/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.auth, required this.onSignedOut})
      : super(key: key);
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postsList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readDataFromDb();
  }

  void readDataFromDb() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Posts');
    await dbRef.get().then((snapshot) {
      var values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        Posts post = Posts(
            image: value['image'],
            description: value['description'],
            date: value['date'],
            time: value['time']);
        postsList.add(post);
      });
      setState(() {});
    });
  }

  void _logOutUser() async {
    try {
      await widget.auth.singOut();
      widget.onSignedOut();
    } catch (e) {
      print('Signout Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jayx Blog'),
      ),
      body: Container(
        child: postsList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: postsList.length,
                itemBuilder: (context, index) {
                  return postUI(
                      postsList[index].image,
                      postsList[index].description,
                      postsList[index].date,
                      postsList[index].time);
                }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        child: Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: _logOutUser,
                icon: const Icon(
                  Icons.logout,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostUploadScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.post_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget postUI(String image, String description, String date, String time) {
  return Card(
    elevation: 10.0,
    margin: const EdgeInsets.all(15.0),
    child: Container(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                time,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Image.network(image, fit: BoxFit.cover),
          CachedNetworkImage(
            imageUrl: image,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            maxLines: 5,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
