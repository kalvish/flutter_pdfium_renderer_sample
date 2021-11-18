import 'dart:ffi';

import 'package:ffi/ffi.dart';

class FPDF_LIBRARY_CONFIG extends Struct {
  // Version number of the interface. Currently must be 2.
  @Int32()
  external int version;

  // Array of paths to scan in place of the defaults when using built-in
  // FXGE font loading code. The array is terminated by a NULL pointer.
  // The Array may be NULL itself to use the default paths. May be ignored
  // entirely depending upon the platform.
  external Pointer<Pointer<Utf8>> userFontPaths;

  // Version 2.

  // pointer to the v8::Isolate to use, or NULL to force PDFium to create one.
  external Pointer<Void> isolate;

  // The embedder data slot to use in the v8::Isolate to store PDFium's
  // per-isolate data. The value needs to be between 0 and
  // v8::Internals::kNumIsolateDataLots (exclusive). Note that 0 is fine
  // for most embedders.
  @Int32()
  external int v8EmbedderSlot;

  factory FPDF_LIBRARY_CONFIG.allocate({
    int version = 2,
    List<String>? userFontPaths,
    Pointer<Void>? isolate,
    int v8EmbedderSlot = 0,
  }) {
    Pointer<Pointer<Utf8>> userFontPathsPtr;
    if (userFontPaths == null) {
      userFontPathsPtr = nullptr;
    } else {
      userFontPathsPtr = calloc<Pointer<Utf8>>();
      for (var i = 0; i < userFontPaths.length; i++) {
        userFontPathsPtr[i] = (userFontPaths[i]).toNativeUtf8();
      }
    }

    return calloc<FPDF_LIBRARY_CONFIG>().ref
      ..version = version
      ..userFontPaths = userFontPathsPtr
      ..isolate = isolate ?? nullptr
      ..v8EmbedderSlot = v8EmbedderSlot;
  }
}

class FPDF_DOCUMENT extends Opaque {}

class FPDF_PAGE extends Opaque {}

class FPDF_BITMAP extends Opaque {}

class FPDF_TEXTPAGE extends Opaque {}

class FPDF_BOOL extends Opaque {}