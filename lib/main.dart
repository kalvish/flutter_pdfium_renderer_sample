// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// import 'file_picker_demo.dart';
// import 'package:flutter/widgets.dart';

// void main() => runApp(FilePickerDemo());

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert' as convertlib;

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfium_2/pdfium/pdfium.dart';

import 'package:file_picker/file_picker.dart';

//remote repo
//https://github.com/kalvish/FlutterPdfiumTest/commits/master
//useful links
//pdfium doc https://pdfium.patagames.com/help/html/M_Patagames_Pdf_Pdfium_FPDF_GetPageSizes.htm
//https://pdfium.googlesource.com/pdfium/+/refs/heads/master/samples/pdfium_test.cc
//https://pdfium.googlesource.com/pdfium/+/refs/heads/master/fpdfsdk/fpdf_view_c_api_test.c
//https://pdfium.googlesource.com/pdfium/+/master/public/fpdf_annot.h
//Utf16 example https://github.com/dart-lang/ffi/issues/35
//pdfium doc https://developers.foxitsoftware.com/resources/pdf-sdk/c_api_reference_pdfium/group___f_p_d_f_i_u_m.html#gaf31488e80db809dd21e4b0e94a266fe6
//dart:ffi samples  https://github.com/dart-lang/samples/blob/master/ffi/primitives/primitives.dart
//flutter device width height https://stackoverflow.com/questions/49553402/flutter-screen-size
//android pdfium fork with text selection and search https://github.com/kalvish/android-support-pdfium/blob/master/library/src/main/java/org/benjinus/pdfium/PdfiumSDK.java
//android pdfium pull request with text seleciton https://github.com/barteksc/PdfiumAndroid/pull/32/files
//android barteksc PDFView https://github.com/barteksc/AndroidPdfViewer/blob/master/android-pdf-viewer/src/main/java/com/github/barteksc/pdfviewer/PDFView.java
//android barteksc Pdfium Core https://github.com/barteksc/PdfiumAndroid/blob/103d5855f797af78a6f33f94cb306ef1c23b2290/src/main/java/com/shockwave/pdfium/PdfiumCore.java#L433
//dartpad custom painter sample https://dartpad.dev/a1bde55a35d88ec7d58fcd0022926ad1
//dartpad custom painter tutorial https://codewithandrea.com/videos/2020-01-27-flutter-custom-painting-do-not-fear-canvas/

void main() async {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  // WidgetsFlutterBinding.ensureInitialized();
  // var base = await path.getApplicationSupportDirectory();
  // loadDylib('${base.path}/debug/libpdfium.dylib');
  loadDylib('');
  initLibrary();

  runApp(new MyApp());
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Pdfium')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var settingsVisible = true;
  String? selectedPdf;
  String _extension = 'pdf';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              settingsVisible = !settingsVisible;
            });
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(title: Text('Settings'));
              },
              body: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Choose PDF'),
                    onPressed: () async {
                      // String selectedPath =
                      //     (await FilePicker.platform.pickFiles(
                      //   type: FileType.custom,
                      //   allowedExtensions: ['pdf'],
                      // )) as String;
                      // setState(() {
                      //   selectedPdf = selectedPath;
                      // });
                      try {
                        List<PlatformFile>? _paths;
                        String? _directoryPath;
                        String? _extension;
                        _directoryPath = null;
                        _paths = (await FilePicker.platform.pickFiles(
                          type: FileType.any,
                          allowMultiple: false,
                          onFileLoading: (FilePickerStatus status) =>
                              print(status),
                          allowedExtensions: (_extension?.isNotEmpty ?? false)
                              ? _extension?.replaceAll(' ', '').split(',')
                              : null,
                        ))
                            ?.files;

                            setState(() {
                              // selectedPdf = _paths != null
                              // ? _paths!.map((e) => e.path).toString()
                              // : '...';
                              selectedPdf = _paths != null
                              ? _paths[0].path
                              : '...';
                              _paths == null;
                            });
                      } on PlatformException catch (e) {
                        //_logException('Unsupported operation' + e.toString());
                      } catch (e) {
                        //_logException(e.toString());
                      }
                    },
                  ),
                  Text(
                    selectedPdf ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              isExpanded: settingsVisible,
            ),
          ],
        ),
        Container(
          child: PdfView(selectedPdf),
        ),
      ],
    );
  }
}

class PdfPainter extends CustomPainter {
  final ui.Image? image;

  PdfPainter(this.image);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset.zero, 20.0, Paint());
    canvas.drawImage(image!, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(PdfPainter oldDelegate) {
    return oldDelegate.image != image;
  }
}

class PdfView extends StatefulWidget {
  final String? filePath;

  PdfView(this.filePath);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  ui.Image? image;

  @override
  void didUpdateWidget(PdfView oldWidget) {
    int width;
    int height;
    int deviceWidth;
    int deviceHeight;
    Pointer<FPDF_PAGE> page;
    Pointer<FPDF_DOCUMENT> doc;
    Pointer<FPDF_BITMAP> bitmap;
    Uint8List buf;

    int ppi = (MediaQuery.of(context).devicePixelRatio * 160).toInt();
     ppi = 100;
    if (widget.filePath == null) return;

    doc = loadDocument(widget.filePath);
    page = fLoadPage!(doc, 0);
    int pageCount = fGetPageCount!(doc);
    fPageSetRotation!(page, 4);
    width = fGetPageWidth!(page).toInt();
    height = fGetPageHeight!(page).toInt();
    width = pointsToPixels(width, ppi).toInt();
    height = pointsToPixels(height, ppi).toInt();
    deviceWidth = MediaQuery.of(context).size.width.toInt();
    deviceHeight = MediaQuery.of(context).size.height.toInt();
    width = 300;
    height = 400;
    bitmap = fBitmapCreate!(width, height, 1);
    fBitmapFillRect!(bitmap, 0, 0, width, height, 0);
    fRenderPageBitmap!(bitmap, page, 0, 0, width, height, 0, 0);

    buf = fBitmapGetBuffer!(bitmap)
        .asTypedList(width * height)
        .buffer
        .asUint8List();

    ui.decodeImageFromPixels(
      buf,
      width,
      height,
      ui.PixelFormat.bgra8888,
      (img) {
        setState(() {
          image = img;
        });
      },
    );

/*
Load FPDF_TEXTPAGE from a FPDF_PAGE
*/
    Pointer<FPDF_TEXTPAGE> fpdf_textpage = fTextLoadPage!(page);
    int error = fGetLastError!();

/*
Check if the input annotation type available or not.
*/
    int isTextAvailable = fAnnotIsSupportedSubtype!(1);
    /*
    If fGetLastError returns 0, it means the method request was successful.
    */
    int errorFAnnotIsSupportedSubtype = fGetLastError!();
    // Pointer<Utf8> extracted_text = fTextGetText(fpdf_textpage,1,3);
    // int errorFTextGetText = fGetLastError();
    /*
    Get text count on a FPDF_TEXTPAGE
    */
    int textCountOnPage = fTextCountChars!(fpdf_textpage);
    List<int> textList =  [];
    for (var i = 0; i < 100; i++) {
      /*
      Get unicode character for each character in a FPDF_TEXTPAGE
      */
      int textUnicode = fTextGetUnicode!(fpdf_textpage, i);
      textList.add(textUnicode);

      // print(textUnicode);
    }
    List<int> textListTemp = [];
    textListTemp.add(101);
    textListTemp.add(83);
    var dec = convertlib.utf8.decode(textList);
    print(dec);

    int countNoOfRectAreas = fTextCountRects!(fpdf_textpage, 0, 100);
    int errorFTextCountRects = fGetLastError!();

    //allocate made it work.
    Pointer<Double> leftP = calloc<Double>();
    Pointer<Double> rightP = calloc<Double>();
    Pointer<Double> bottomP = calloc<Double>();
    Pointer<Double> topP = calloc<Double>();
    fTextGetCharBox!(fpdf_textpage, 0, leftP, rightP, bottomP, topP);
    // calloc.free(leftP);
    int errorFTextGetCharBox = fGetLastError!();
    /*
    Close FPDF_TEXTPAGE after all related operations
    */
    fTextClosePage!(fpdf_textpage);
    int errorFTextClosePage = fGetLastError!();

    // String test = extracted_text.toString();
    // String text = Utf8.fromUtf8(extracted_text);

    fCloseDocument!(doc);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePath == null) {
      return Container();
    }
    if (image == null) {
      return CircularProgressIndicator();
    }
    return CustomPaint(
      painter: PdfPainter(image),
    );
  }
}
