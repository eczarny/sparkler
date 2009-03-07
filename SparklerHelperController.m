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
// SparklerHelperController.m
// 
// Created by Eric Czarny on Wednesday, November 26, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerHelperController.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerHelperController (SparklerHelperControllerPrivate)

- (void)createStatusItem;

- (NSMenu *)createStatusMenu;

- (void)destroyStatusItem;

#pragma mark -

- (void)postDistributedNotificationName: (NSString *)notificationName;

@end

#pragma mark -

@implementation SparklerHelperController

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    NSDistributedNotificationCenter *notificationCenter = [NSDistributedNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(scanForApplications:)
                               name: SparklerScanForApplicationsNotification
                             object: SparklerHelperControllerName];
    
    [notificationCenter addObserver: self
                           selector: @selector(showStatusItem:)
                               name: SparklerShowStatusItemNotification
                             object: SparklerHelperControllerName];
    
    [notificationCenter addObserver: self
                           selector: @selector(hideStatusItem:)
                               name: SparklerHideStatusItemNotification
                             object: SparklerHelperControllerName];
    
    [notificationCenter addObserver: self
                           selector: @selector(startUpdateEngine:)
                               name: SparklerStartUpdateEngineNotification
                             object: SparklerHelperControllerName];
    
    [notificationCenter addObserver: self
                           selector: @selector(stopUpdateEngine:)
                               name: SparklerStopUpdateEngineNotification
                             object: SparklerHelperControllerName];
    
    [self createStatusItem];
    
    [self postDistributedNotificationName: SparklerHelperDidLaunchNotification];
}

- (void)applicationShouldTerminate: (NSNotification *)notification {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark -

- (void)checkForUpdates: (id)sender {
    NSLog(@"checkForUpdates:");
}

#pragma mark -

- (void)openSparkler: (id)sender {
    NSString *sparklerApplicationPath = [[SparklerUtilities sparklerBundle] bundlePath];
    
    [[NSWorkspace sharedWorkspace] openFile: sparklerApplicationPath];
}

#pragma mark -

- (void)showStatusItem: (NSNotification *)notification {
    [self createStatusItem];
}

- (void)hideStatusItem: (NSNotification *)notification {
    [self destroyStatusItem];
}

#pragma mark -

- (void)startUpdateEngine: (NSNotification *)notification {
    NSLog(@"startUpdateEngine:");
}

- (void)stopUpdateEngine: (NSNotification *)notification {
    NSLog(@"stopUpdateEngine:");
}

@end

#pragma mark -

@implementation SparklerHelperController (SparklerHelperControllerPrivate)

- (void)createStatusItem {
    NSMenu *statusMenu = nil;
    
    if (myStatusItem) {
        return;
    }
    
    myStatusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength] retain];
    
    [myStatusItem setTitle: @"Sparkler"];
    
    statusMenu = [self createStatusMenu];
    
    [myStatusItem setMenu: statusMenu];
    [myStatusItem setToolTip: @"Sparkler"];
    [myStatusItem setHighlightMode: YES];
    
    [statusMenu release];
}

- (NSMenu *)createStatusMenu {
    NSMenu *statusMenu = [[NSMenu allocWithZone: [NSMenu menuZone]] init];
    
    [statusMenu addItemWithTitle: @"Last Scan: Never" action: NULL keyEquivalent: @""];
    [statusMenu addItem: [NSMenuItem separatorItem]];
    [statusMenu addItemWithTitle: @"Check for Updates..." action: @selector(checkForUpdates:) keyEquivalent: @""];
    [statusMenu addItem: [NSMenuItem separatorItem]];
    [statusMenu addItemWithTitle: @"Open Sparkler..." action: NULL keyEquivalent: @""];
    
    return statusMenu;
}

- (void)destroyStatusItem {
    [[NSStatusBar systemStatusBar] removeStatusItem: myStatusItem];
    
    [myStatusItem release];
    
    myStatusItem = nil;
}

#pragma mark -

- (void)postDistributedNotificationName: (NSString *)notificationName {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName: notificationName object: SparklerHelperControllerName];
}

@end
