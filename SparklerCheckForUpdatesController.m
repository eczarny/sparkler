// 
// Copyright (c) 2010 Eric Czarny <eczarny@gmail.com>
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
// SparklerCheckForUpdatesController.h
// 
// Created by Eric Czarny on Sunday, May 3, 2009.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerCheckForUpdatesController.h"
#import "SparklerApplicationUpdateManager.h"
#import "SparklerApplicationUpdatesWindowController.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerCheckForUpdatesController

- (void)awakeFromNib {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    myApplicationUpdateManager = [SparklerApplicationUpdateManager sharedManager];
    
    [notificationCenter addObserver: self
                           selector: @selector(sparklerWillCheckForApplicationUpdates:)
                               name: SparklerWillCheckForApplicationUpdatesNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(sparklerDidFindApplicationUpdates:)
                               name: SparklerDidFindApplicationUpdatesNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(sparklerDidNotFindApplicationUpdates:)
                               name: SparklerDidNotFindApplicationUpdatesNotification
                             object: nil];
}

#pragma mark -

- (NSView *)checkForUpdatesView {
    return myCheckForUpdatesView;
}

#pragma mark -

- (void)checkForUpdates: (id)sender {
    [myApplicationUpdateManager checkForUpdates];
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Update Engine Notifications

#pragma mark -

- (void)sparklerWillCheckForApplicationUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator startAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: NO];
}

#pragma mark -

- (void)sparklerDidFindApplicationUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
    
    [myApplicationUpdatesWindowController displayInstallUpdatesView];
}

- (void)sparklerDidNotFindApplicationUpdates: (NSNotification *)notification {
    NSWindow *sparklerWindow = [myApplicationUpdatesWindowController window];
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    
    [alert addButtonWithTitle: SparklerLocalizedString(@"OK")];
    
    [alert setMessageText: SparklerLocalizedString(@"There are no updates available.")];
    [alert setInformativeText: SparklerLocalizedString(@"Sparkler was unable to find any updates. Please try checking again later.")];
    
    [alert setAlertStyle: NSInformationalAlertStyle];
    
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
    
    [alert beginSheetModalForWindow: sparklerWindow modalDelegate: self didEndSelector: NULL contextInfo: nil];
}

@end
