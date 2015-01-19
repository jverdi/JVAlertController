JVAlertController
=======================
[![Build Status](https://travis-ci.org/jverdi/JVAlertController.svg?branch=master)](https://travis-ci.org/jverdi/JVAlertController)
[![Pod Version](http://img.shields.io/cocoapods/v/JVAlertController.svg)](http://cocoadocs.org/docsets/JVAlertController/)
[![Pod Platform](http://img.shields.io/cocoapods/p/JVAlertController.svg)](http://cocoadocs.org/docsets/JVAlertController/)
[![Pod License](http://img.shields.io/cocoapods/l/JVAlertController.svg)](http://jaredverdi.mit-license.org)

Description
-----------

`JVAlertController` is an API-compatible backport of UIAlertController for iOS 7. 

Why
---

Consider the following scenario:  
1. You wish to distribute a static library.  
2. You wish for said static library to support iOS 7.  
3. Your static library includes.  
4. You also wish for that static library to be available for use in iOS 8 extensions.  

Problem:  
`UIAlertView` and `UIActionSheet` are `NS_EXTENSION_UNAVAILABLE` [restricted APIs](https://gist.github.com/jverdi/b7c0dc4e2d8d8e58cc4a) and thus, cannot be used in iOS 8 extensions. Even runtime checks that pass your calls to `UIAlertView`/`UIActionSheet` on iOS 7, and `UIAlertController` on iOS 8 don't solve this problem.

How to use it
-------------

Simply make calls to `UIAlertController` exactly as you normally would.  
- On iOS 8, `JVAlertController` will do absolutely nothing -- all work is done by the system frameworks.  
- On iOS 7, through some objc-runtime magic, all calls will be translated to `JVAlertController`, and will behave like `UIAlertView` and `UIActionSheet` do on iOS 7.  

Notes
-----
- The `UIAlertView`/`UIActionSheet` iOS 7 APIs are not 100% translateable to `UIAlertController`. Specifically, the concepts of `showFromToolbar:`, `showFromTabBar:`, and `showFromRect:` don't exist. For this reason, `JVAlertController` mimics the iOS 8 implementation of `UIAlertController` in some respects.
- Views rendered by `JVAlertController` are not quite pixel-perfect representations of their framework counterparts. This is largely due to visual effects that Apple employs which are tucked away inside their private classes. That being said, it's unlikely that users will notice any significant differences.
- `JVAlertController` does not go out of its way to recreate bugs in the iOS 7 implementations of `UIAlertView` or `UIActionSheet`. (Turn on `USE_SYSTEM_IOS7_IMPLEMENTATION` in `Config.h` and you should be able to find some examples)
- If you find any inconsistencies between `JVAlertController` and the standard iOS 7 alerts/action sheets, please do open a gissue.

References
----------
`JVAlertController` borrows some ObjC run-time asm sorcery from [Cédric Luthi's NSUUID project](https://github.com/0xced/NSUUID)

Author
------
Jared Verdi
- [@jverdi](http://www.twitter.com/jverdi)

License
-------
The MIT License (MIT)
Copyright © 2015 Jared Verdi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
