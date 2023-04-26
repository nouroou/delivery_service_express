import 'dart:io';
import 'dart:html' as html;
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:sh_express_transport/utils/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String username, email, name, password;
  late String fileName;
  Map documents = {
    'W9': null,
    'DL': null,
    'DIL Insurance': null,
    'Drivers License': null,
    'Vehcile Registration': null,
    'Contract': null,
  };
  List _images = [];
  // List<html.File>? _images = [];
  bool _passwordHidden = true;
  bool _submitting = false;

  void _showPassword() {
    setState(() {
      _passwordHidden = !_passwordHidden;
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  late FocusNode emailNode;
  late FocusNode passwordNode;
  late FocusNode nameNode;
  late FocusNode usernameNode;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500, minWidth: 180),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SH Express',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Text('Transport',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Constants().sizedBoxLarge,
                  _usernameFIeld(context),
                  Constants().sizedBox,
                  _nameField(context),
                  Constants().sizedBox,
                  _emailField(context),
                  Constants().sizedBox,
                  _passwordField(context),
                  Constants().sizedBox,
                  Text(
                    'Driver Documents',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Constants().sizedBox,
                  _chipList(context),
                  Constants().sizedBox,
                  Text(
                    'Truck Photos:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Constants().sizedBox,
                  _imagesRow(context),
                  Constants().sizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _registerButton(),
                      const SizedBox(height: 20),
                      _loginButton(context),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  TextFormField _usernameFIeld(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      validator: (value) => EmailValidator.validate(value.toString())
          ? null
          : 'Please type a valid username',
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, usernameNode, nameNode);
      },
      onChanged: (value) => username = value,
      decoration: const InputDecoration(
        hintText: 'Username',
        prefixIcon: Icon(CupertinoIcons.person_badge_plus, size: 20),
      ),
    );
  }

  TextFormField _nameField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      validator: (value) => EmailValidator.validate(value.toString())
          ? null
          : 'Please type your legal name',
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, nameNode, emailNode);
      },
      onChanged: (value) => name = value,
      decoration: const InputDecoration(
        hintText: 'Name',
        prefixIcon: Icon(CupertinoIcons.rectangle_stack_person_crop, size: 20),
      ),
    );
  }

  TextFormField _emailField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      validator: (value) => EmailValidator.validate(value.toString())
          ? null
          : 'Please type a correct email',
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, emailNode, passwordNode);
      },
      onChanged: (value) => email = value,
      decoration: const InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(CupertinoIcons.mail, size: 20),
      ),
    );
  }

  TextFormField _passwordField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: _passwordHidden,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, emailNode, _submit());
      },
      validator: (value) {
        RegExp regex = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value!.isEmpty) {
          return 'Please enter password';
        } else {
          if (!regex.hasMatch(value)) {
            return 'Enter valid password';
          } else {
            return null;
          }
        }
      },
      onChanged: (value) => password = value,
      decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(CupertinoIcons.lock, size: 20),
          suffixIcon: InkWell(
              onTap: () => _showPassword(),
              child: Icon(
                _passwordHidden
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill,
                size: 20,
              ))),
    );
  }

  TextButton _loginButton(BuildContext context) {
    return TextButton(
      child: const Text('Have an account? Login'),
      onPressed: () => Navigator.pop(context, false),
    );
  }

  pickFile(String fileNum) async {
    FilePickerCross filePickerCross = await FilePickerCross.importFromStorage(
            type: FileTypeCross.any, fileExtension: 'pdf')
        .then((value) {
      String fileName = basename(value.path!);
      debugPrint('file BEFORE $documents');
      debugPrint('file NAME IS $fileName');
      var truePath =
          value.saveToPath(path: 'sh_express_transport/temporary/documents/');

      setState(() {
        documents.update(fileNum, (v) => File(value.path.toString()));
      });
      debugPrint('file After $documents');
      return value;
    });
  }

  _deleteFile(String fileNum, File file) async {
    setState(() {
      documents.update(fileNum, (v) => null);
    });
    print('DOCS AFTER DELETE $documents');
  }

  Widget _chipList(BuildContext context) {
    return Wrap(
        direction: Axis.horizontal,
        spacing: 5,
        runSpacing: 16,
        children: [
          for (var doc in documents.entries)
            InkWell(
              splashColor: Theme.of(context).splashColor,
              hoverColor: Theme.of(context).hoverColor,
              focusColor: Theme.of(context).primaryColor,
              radius: 14,
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                if (doc.value != null && doc.value != '') {
                  _openDoc(context, doc.value);
                } else {
                  await pickFile(doc.key);
                }
              },
              child: doc.value != '' && doc.value != null
                  ? Chip(
                      avatar: SvgPicture.asset('images/pdf.svg',
                          height: 16,
                          width: 16,
                          color: Colors.white,
                          semanticsLabel: 'PDF'),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      backgroundColor: Theme.of(context).primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      deleteIcon: const Icon(
                        CupertinoIcons.xmark_circle,
                        size: 16,
                      ),
                      deleteButtonTooltipMessage: 'Clear',
                      deleteIconColor: Colors.white,
                      onDeleted: () => setState(() {
                            _deleteFile(doc.key, doc.value);
                          }),
                      labelStyle: Theme.of(context).primaryTextTheme.button,
                      label: Text(basename(doc.value.toString())))
                  : Chip(
                      avatar: const Icon(CupertinoIcons.share_up, size: 20),
                      label: Text(doc.key.toString())),
            ),
        ]);
  }

  Widget _registerButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: _submitting == true
                ? const EdgeInsets.symmetric(vertical: 10, horizontal: 0)
                : null),
        onPressed: () => _submit(),
        child: _submitting == true
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 0.8,
              )
            : const Text('REGISTER'));
  }

  Widget _imagesRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var image = 0; image < _images.length; image++)
            Stack(alignment: Alignment.bottomCenter, children: [
              Stack(alignment: Alignment.topRight, children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(6)),
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  height: 120,
                  width: 190,
                  child: Image(image: _images[image], fit: BoxFit.fill),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _repickImage(image),
                        child: Container(
                            margin: const EdgeInsets.only(
                                right: 4, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(CupertinoIcons.pen,
                                size: 16, color: Colors.white)),
                      ),
                      GestureDetector(
                        onTap: () => _removeImage(image),
                        child: Container(
                            margin: const EdgeInsets.only(
                                right: 4, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(CupertinoIcons.delete,
                                size: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                )
              ]),
              Container(
                  child: Text(basename(''),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)),
                  width: 190,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6))))
            ]),
          if (_images.length != 5)
            Container(
              margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => _pickImage(),
                hoverColor: Theme.of(context).hoverColor,
                splashColor: Theme.of(context).splashColor,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(6)),
                  height: 120,
                  width: 190,
                  child: const Icon(CupertinoIcons.add_circled_solid, size: 48),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _pickImage() async {
    // Uncomment in case if you wanted to import images as a ready image widget (NOTE: It requires more work to get it into firebase)
    // Image? imageFile = await ImagePickerWeb.getImageAsWidget();
    // setState(() {
    //   _images.add(imageFile);
    // });

    // In case if you wanted to import images as bytes
    Uint8List? imageFile = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      var _image = MemoryImage(imageFile!);
      _images.add(_image);
    });

    // Uncomment in case if you wanted to import images as files (NOTE: web is not supported)
    // html.File? imageFile = await ImagePickerWeb.getImageAsFile().then((value) {
    //   setState(() {
    //     _images.add(value!);
    //   });
    // });

    if (imageFile != null) {
      print('Images loaded');
    } else {
      print('Images loaded');
    }
  }

  _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    print('Image removed');
  }

  _repickImage(int index) async {
    // Uncomment in case if you wanted to import images as a ready image widget (NOTE: It requires more work to get it into firebase)
    // Image? imageFile = await ImagePickerWeb.getImageAsWidget();
    // setState(() {
    //   _images.removeAt(index);
    //   _images.insert(index, imageFile!);
    // });

    // In case if you wanted to import images as bytes
    Uint8List? imageFile = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      var _image = MemoryImage(imageFile!);
      _images.removeAt(index);
      _images.insert(index, _image);
    });

    // Uncomment in case if you wanted to import images as files (NOTE: web is not supported)
    // html.File? imageFile = await ImagePickerWeb.getImageAsFile().then((value) {
    //   setState(() {
    // _images.removeAt(index);
    // _images.insert(index, value!);
    //   });
    // });

    if (imageFile != null) {
      print('Images Reloaded');
    } else {
      print('Images Not Reloaded');
    }
  }

  _submit() {
    setState(() {
      _submitting = true;
    });
    if (email.isNotEmpty &&
        email != '' &&
        name.isNotEmpty &&
        name != '' &&
        username.isNotEmpty &&
        username != '' &&
        password.isNotEmpty &&
        password != '' &&
        _images.length == 5 &&
        _images != null &&
        documents.values != null) {
      print('Username: $username');
      print('Username: $name');
      print('Username: $email');
      print('Username: $password');
      print('Username: $_images');
      print('Username: $documents');
      print('PROFILE IS READDYY!');
      setState(() {
        _submitting = false;
      });
    } else {
      print('PROFILE IS NOT READY!');
      setState(() {
        _submitting = false;
      });
    }
  }

  _openDoc(BuildContext context, File file) {
    print('FILE SOURCE ${file.path}');
    showDialog(
        useSafeArea: true,
        context: context,
        builder: (_) {
          return Container(
            margin: const EdgeInsets.all(40),
            child: Scaffold(
                appBar: AppBar(
                  leading: CloseButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  centerTitle: true,
                  title: Text(
                    basename(file.path),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                body: SfPdfViewer.file(
                  file,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    print(details.document.pages.count);
                  },
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    showErrorDialog(
                        context, details.error, details.description);
                  },
                )),
          );
        });
  }

  void showErrorDialog(BuildContext context, String error, String description) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
