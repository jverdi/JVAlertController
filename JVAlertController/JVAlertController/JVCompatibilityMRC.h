//
//  JVAlertController.m
//  JVAlertController
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolaus Rosenmayr
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// JVAlertController is not meant to be instantiated directly,
// which is why there is no JVAlertController.h

// JVAlertController serves as a template class,
// to be injected via the objc runtime as "UIAlertController"
// Once this class and its accompanying files are imported into your project,
// you can use the standard UIAlertController APIs freely on iOS 7



#ifndef JV_RETAIN_OBJECT
    #if __has_feature(objc_arc)
        #define JV_RETAIN_OBJECT(obj)
    #else
        #define JV_RETAIN_OBJECT(obj) [obj retain]
    #endif
#endif


#ifndef JV_RELEASE_OBJECT
    #if __has_feature(objc_arc)
        #define JV_RELEASE_OBJECT(obj)
    #else
        #define JV_RELEASE_OBJECT(obj) [obj release]
    #endif
#endif

#ifndef JV_AUTORELEASE_OBJECT
    #if __has_feature(objc_arc)
        #define JV_AUTORELEASE_OBJECT(obj)
    #else
        #define JV_AUTORELEASE_OBJECT(obj) [obj autorelease]
    #endif
#endif

#ifndef __typeof
    #define __typeof(obj) __typeof__(obj)
#endif

#ifndef typeof
    #define typeof(obj) __typeof(obj)
#endif

#ifndef JV_FOR_BLOCK
    #if __has_feature(objc_arc)
        #define JV_FOR_BLOCK
    #else
        #define JV_FOR_BLOCK __block
    #endif
#endif


#ifndef JV_WEAK_REFERENCE_FOR_BLOCK
    #if __has_feature(objc_arc)
        #define JV_WEAK_REFERENCE_FOR_BLOCK __weak
    #else
        #define JV_WEAK_REFERENCE_FOR_BLOCK __block
    #endif
#endif

#ifndef JV_STRONG_PROPERTY
    #if __has_feature(objc_arc)
        #define JV_STRONG_PROPERTY strong
    #else
        #define JV_STRONG_PROPERTY retain
    #endif
#endif

#ifndef JV_WEAK_PROPERTY
    #if __has_feature(objc_arc)
        #define JV_WEAK_PROPERTY weak
    #else
        #define JV_WEAK_PROPERTY assign
    #endif
#endif

#ifndef JV_SUPER_DEALLOC
    #if __has_feature(objc_arc)
        #define JV_SUPER_DEALLOC
    #else
        #define JV_SUPER_DEALLOC [super dealloc];
    #endif
#endif


