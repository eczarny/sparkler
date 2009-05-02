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
// SparklerApplicationController.m
// 
// Created by Eric Czarny on Thursday, December 11, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerApplicationController.h"
#import "SparklerPreferencesWindowController.h"
#import "SparklerApplicationUpdatesWindowController.h"
#import "SparklerPreferencePaneManager.h"
#import "SparklerUtilities.h"

@implementation SparklerApplicationController

- (id)init {
    if (self = [super init]) {
        myPreferencesWindowController = [SparklerPreferencesWindowController sharedController];
    }
    
    return self;
}

#pragma mark -

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    [myPreferencesWindowController loadPreferencePanes];
    
    [self toggleSparklerWindow: self];
}

#pragma mark -

- (IBAction)togglePreferencesWindow: (id)sender {
    [myPreferencesWindowController togglePreferencesWindow: sender];
}

#pragma mark -

- (IBAction)toggleSparklerWindow: (id)sender {
    [[SparklerApplicationUpdatesWindowController sharedController] toggleSparklerWindow: sender];
}

@end
