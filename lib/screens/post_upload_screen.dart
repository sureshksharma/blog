import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PostUploadScreen extends StatefulWidget {
  const PostUploadScreen({Key? key}) : super(key: key);

  @override
  State<PostUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();
  String? _desc;
  String? _url;

  Future getImage() async {
    var tempImage =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    setState(() {
      selectedImage = File(tempImage!.path);
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadPost() async {
    if (validateAndSave()) {
      final postImageRef = FirebaseStorage.instance.ref().child('Public Posts');
      var timestamp = DateTime.now();
      final UploadTask uploadTask = postImageRef
          .child(timestamp.toString() + '.jpg')
          .putFile(selectedImage!);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      _url = imageUrl.toString();
      print('ImageURL: $_url');
      moveToHome();
      savetoDatabase(_url);
    }
  }

  void moveToHome() {
    Navigator.pop(context);
  }

  void savetoDatabase(url) {
    var dbTimestamp = DateTime.now();
    var formatedDate = DateFormat('MMM d, yyyy');
    var formatedTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatedDate.format(dbTimestamp);
    String time = formatedTime.format(dbTimestamp);

    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    var data = {'image': url, 'description': _desc, 'date': date, 'time': time};
    dbRef.child('Posts').push().set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Post'),
      ),
      body: Center(
        child: selectedImage == null
            ? const Text('Select an image.')
            : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: const Icon(Icons.upload),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Image.file(
              selectedImage!,
              height: 300.0,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 15.0),
            TextFormField(
              validator: (value) {
                return value!.isEmpty
                    ? 'Description required to upload post.'
                    : null;
              },
              onSaved: (value) {
                _desc = value!;
              },
              decoration: const InputDecoration(
                  labelText: 'Description', hintText: 'Enter Description'),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: uploadPost,
              child: const Text('Upload Post'),
            ),
          ],
        ),
      ),
    );
  }
}
