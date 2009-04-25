// 
// Copyright (c) 2009 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

// 
// Sparkler
// SparklerPreferencesController.h
// 
// Created by Eric Czarny on Friday, December 12, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class SparklerPreferencePaneManager;

@interface SparklerPreferencesWindowController : NSWindowController {
    NSToolbar *myToolbar;
    NSMutableDictionary *myToolbarItems;
    SparklerPreferencePaneManager *myPreferencePaneManager;
}

+ (SparklerPreferencesWindowController *)sharedController;

#pragma mark -

- (void)showPreferencesWindow: (id)sender;

- (void)hidePreferencesWindow: (id)sender;

#pragma mark -

- (void)togglePreferencesWindow: (id)sender;

#pragma mark -

- (void)loadPreferencePanes;

#pragma mark -

- (NSArray *)loadedPreferencePanes;

@end
