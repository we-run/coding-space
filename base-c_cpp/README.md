



### 使用  VS 开发C/C++ 程序
(VS 使用实例)[https://devblogs.microsoft.com/cppblog/getting-started-with-visual-studio-for-c-and-cpp-development/]
(Qt 应用导入到VS)[https://devblogs.microsoft.com/cppblog/bring-your-existing-qt-projects-to-visual-studio/]


- (在VS 中使用其他编译器)[https://devblogs.microsoft.com/cppblog/using-mingw-and-cygwin-with-visual-cpp-and-open-folder/]
- (在VS 中使用其他编译器 2)[https://docs.microsoft.com/en-us/cpp/build/open-folder-projects-cpp?view=msvc-170]
- (在VS 中使用其他编译器 3)[https://docs.microsoft.com/en-us/visualstudio/ide/develop-code-in-visual-studio-without-projects-or-solutions?view=vs-2022]




### 编译
```shell
/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang 
-x \
c++ \
-target \
x86_64-apple-macos12.3 \
-fmessage-length\=0 \
-fdiagnostics-show-note-include-stack \
-fmacro-backtrace-limit\=0 \
-std\=gnu++14 \
-fmodules \
-gmodules \
-fmodules-cache-path\=/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/ModuleCache.noindex \
-fmodules-prune-interval\=86400 \
-fmodules-prune-after\=345600 \
-fbuild-session-file\=/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/ModuleCache.noindex/Session.modulevalidation \
-fmodules-validate-once-per-build-session \
-Wnon-modular-include-in-framework-module \
-Werror\=non-modular-include-in-framework-module \
-Wno-trigraphs \
-fpascal-strings \
-O0 \
-fno-common \
-Wno-missing-field-initializers \
-Wno-missing-prototypes \
-Werror\=return-type \
-Wdocumentation \
-Wunreachable-code \
-Wquoted-include-in-framework-header \
-Werror\=deprecated-objc-isa-usage \
-Werror\=objc-root-class \
-Wno-non-virtual-dtor \
-Wno-overloaded-virtual \
-Wno-exit-time-destructors \
-Wno-missing-braces \
-Wparentheses \
-Wswitch \
-Wunused-function \
-Wno-unused-label \
-Wno-unused-parameter \
-Wunused-variable \
-Wunused-value \
-Wempty-body \
-Wuninitialized \
-Wconditional-uninitialized \
-Wno-unknown-pragmas \
-Wno-shadow \
-Wno-four-char-constants \
-Wno-conversion \
-Wconstant-conversion \
-Wint-conversion \
-Wbool-conversion \
-Wenum-conversion \
-Wno-float-conversion \
-Wnon-literal-null-conversion \
-Wobjc-literal-conversion \
-Wshorten-64-to-32 \
-Wno-newline-eof \
-Wno-c++11-extensions \
-DDEBUG\=1 \
-isysroot \
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.3.sdk \
-fasm-blocks \
-fstrict-aliasing \
-Wdeprecated-declarations \
-Winvalid-offsetof \
-g \
-fvisibility-inlines-hidden \
-Wno-sign-conversion \
-Winfinite-recursion \
-Wmove \
-Wcomma \
-Wblock-capture-autoreleasing \
-Wstrict-prototypes \
-Wrange-loop-analysis \
-Wno-semicolon-before-method-body \
-Wunguarded-availability \
-index-store-path \
/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Index/DataStore \
-iquote \
/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/cv_test-generated-files.hmap \
-I/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/cv_test-own-target-headers.hmap \
-I/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/cv_test-all-target-headers.hmap \
-iquote \
/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/cv_test-project-headers.hmap \
-I/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Products/Debug/include \
-I/usr/local/include/opencv4 \
-I/usr/local/include/opencv4/opencv2 \
-I/usr/local/include/opencv4/opencv2/calib3d \
-I/usr/local/include/opencv4/opencv2/core \
-I/usr/local/include/opencv4/opencv2/dnn \
-I/usr/local/include/opencv4/opencv2/features2d \
-I/usr/local/include/opencv4/opencv2/flann \
-I/usr/local/include/opencv4/opencv2/gapi \
-I/usr/local/include/opencv4/opencv2/highgui \
-I/usr/local/include/opencv4/opencv2/imgcodecs \
-I/usr/local/include/opencv4/opencv2/imgproc \
-I/usr/local/include/opencv4/opencv2/ml \
-I/usr/local/include/opencv4/opencv2/objdetect \
-I/usr/local/include/opencv4/opencv2/photo \
-I/usr/local/include/opencv4/opencv2/stitching \
-I/usr/local/include/opencv4/opencv2/video \
-I/usr/local/include/opencv4/opencv2/videoio \
-I/usr/local/include/opencv4/opencv2/core/cuda \
-I/usr/local/include/opencv4/opencv2/core/detail \
-I/usr/local/include/opencv4/opencv2/core/hal \
-I/usr/local/include/opencv4/opencv2/core/opencl \
-I/usr/local/include/opencv4/opencv2/core/utils \
-I/usr/local/include/opencv4/opencv2/dnn/utils \
-I/usr/local/include/opencv4/opencv2/features2d/hal \
-I/usr/local/include/opencv4/opencv2/gapi/cpu \
-I/usr/local/include/opencv4/opencv2/gapi/fluid \
-I/usr/local/include/opencv4/opencv2/gapi/gpu \
-I/usr/local/include/opencv4/opencv2/gapi/infer \
-I/usr/local/include/opencv4/opencv2/gapi/ocl \
-I/usr/local/include/opencv4/opencv2/gapi/own \
-I/usr/local/include/opencv4/opencv2/gapi/plaidml \
-I/usr/local/include/opencv4/opencv2/gapi/render \
-I/usr/local/include/opencv4/opencv2/gapi/s11n \
-I/usr/local/include/opencv4/opencv2/gapi/streaming \
-I/usr/local/include/opencv4/opencv2/gapi/util \
-I/usr/local/include/opencv4/opencv2/imgcodecs/legacy \
-I/usr/local/include/opencv4/opencv2/imgproc/detail \
-I/usr/local/include/opencv4/opencv2/imgproc/hal \
-I/usr/local/include/opencv4/opencv2/photo/legacy \
-I/usr/local/include/opencv4/opencv2/stitching/detail \
-I/usr/local/include/opencv4/opencv2/video/legacy \
-I/usr/local/include/opencv4/opencv2/videoio/legacy \
-I/usr/local/include/opencv4/opencv2/core/cuda/detail \
-I/usr/local/include/opencv4/opencv2/core/opencl/runtime \
-I/usr/local/include/opencv4/opencv2/core/opencl/runtime/autogenerated \
-I/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/DerivedSources-normal/x86_64 \
-I/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/DerivedSources/x86_64 \
-I/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/DerivedSources \
-F/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Products/Debug \
-MMD \
-MT \
dependencies \
-MF \
/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/Objects-normal/x86_64/cv.d \
--serialize-diagnostics \
/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/Objects-normal/x86_64/cv.dia \
-c \
/Volumes/DFQ/PAN/DEVSpace/Labs/coding-space/ai/codes/cv_test/cv_test/cv.cpp \
-o \
/Users/dongfuqiang/Library/Developer/Xcode/DerivedData/cv_test-cfrzpkrhozturhaefrfayyztsoww/Build/Intermediates.noindex/cv_test.build/Debug/cv_test.build/Objects-normal/x86_64/cv.o \
-index-unit-output-path \
/cv_test.build/Debug/cv_test.build/Objects-normal/x86_64/cv.o

```



```

    -Wconditional-uninitialized
    -Wall
    -Wnullable-to-nonnull-conversion
    -Wmissing-method-return-type
    -Woverlength-strings

    /usr/local/include/opencv4
    /usr/local/lib

    clang++ -Wmissing-method-return-type -Woverlength-strings -Wnullable-to-nonnull-conversion -Wconditional-uninitialized -Wc++11-extensions -I/usr/local/include/opencv4 -L/usr/local/lib \
    -Wno-non-virtual-dtor \
    -Wno-overloaded-virtual \
    -Wno-exit-time-destructors \
    -Wno-missing-braces \
    -Wparentheses \
    -Wswitch \
    -Wunused-function \
    -Wno-unused-label \
    -Wno-unused-parameter \
    -Wunused-variable \
    -Wunused-value \
    -Wempty-body \
    -Wuninitialized \
    -Wconditional-uninitialized \
    -Wno-unknown-pragmas \
    -Wno-shadow \
    -Wno-four-char-constants \
    -Wno-conversion \
    -Wconstant-conversion \
    -Wint-conversion \
    -Wbool-conversion \
    -Wenum-conversion \
    -Wno-float-conversion \
    -Wnon-literal-null-conversion \
    -Wobjc-literal-conversion \
    -Wshorten-64-to-32 \
    -Wno-newline-eof \
    -Wno-c++11-extensions \
    -DDEBUG\=1 \
    -std\=gnu++14 \
    -lopencv_features2d.4.5.0 \
    -lopencv_photo.4.5.0 \
    -lopencv_imgcodecs.4.5.0 \
    -lopencv_video.4.5.0 \
    -lopencv_calib3d.4.5.0 \
    -lopencv_imgproc.4.5.0 \
    -lopencv_highgui.4.5.0 \
    -lopencv_gapi.4.5.0 \
    -lopencv_dnn.4.5.0 \
    -lopencv_videoio.4.5.0 \
    -lopencv_ml.4.5.0 \
    -lopencv_core.4.5.0 \
    -lopencv_objdetect.4.5.0 \
    -lopencv_flann.4.5.0 \
    -lopencv_stitching.4.5.0 \
    main.cpp cv.cpp  -o der
```
