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
// SparklerUpdatesWindowController.m
// 
// Created by Eric Czarny on Saturday, April 25, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerUpdatesWindowController.h"
#import "SparklerApplicationUpdateManager.h"
#import "SparklerConstants.h"

@interface SparklerUpdatesWindowController (SparklerUpdatesWindowControllerPrivate)

- (void)windowDidLoad;

#pragma mark -

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title;

#pragma mark -

- (void)displayCheckForUpdatesView;

- (void)displayInstallUpdatesView;

#pragma mark -

- (void)sparklerWillCheckForApplicationUpdates: (NSNotification *)notification;

#pragma mark -

- (void)sparklerDidFindApplicationUpdates: (NSNotification *)notification;

- (void)sparklerDidNotFindApplicationUpdates: (NSNotification *)notification;

@end

#pragma mark -

@implementation SparklerUpdatesWindowController

static SparklerUpdatesWindowController *sharedInstance = nil;

- (id)init {
    if (self = [super initWithWindowNibName: SparklerUpdatesWindowNibName]) {
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
    
    return self;
}

#pragma mark -

+ (SparklerUpdatesWindowController *)sharedController {
    if (!sharedInstance) {
        sharedInstance = [[SparklerUpdatesWindowController alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (void)showSparklerWindow: (id)sender {
    [self showWindow: sender];
}

- (void)hideSparklerWindow: (id)sender {
    [[self window] performClose: sender];
}

#pragma mark -

- (void)toggleSparklerWindow: (id)sender {
    if ([[self window] isKeyWindow]) {
        [self hideSparklerWindow: sender];
    } else {
        [self showSparklerWindow: sender];
    }
}

#pragma mark -

- (IBAction)checkForUpdates: (id)sender {
    [myApplicationUpdateManager checkForUpdates];
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SparklerUpdatesWindowController (SparklerUpdatesWindowControllerPrivate)

- (void)windowDidLoad {
    [[self window] center];
    
    [self displayCheckForUpdatesView];
}

#pragma mark -

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title {
    NSWindow *updatesWindow = [self window];
    NSView *transitionView = [[NSView alloc] initWithFrame: [[updatesWindow contentView] frame]];
    NSRect updatesWindowFrame = [updatesWindow frame];
    
    [updatesWindow setContentView: transitionView];
    
    [transitionView release];
    
    updatesWindowFrame.size.height = [view frame].size.height + (updatesWindowFrame.size.height - [[updatesWindow contentView] frame].size.height);
    updatesWindowFrame.size.width = [view frame].size.width;
    
    if ([view frame].size.height > [[updatesWindow contentView] frame].size.height) {
        updatesWindowFrame.origin.y -= [[updatesWindow contentView] frame].size.height + ([view frame].size.height * 0.25);
    } else if ([view frame].size.height < [[updatesWindow contentView] frame].size.height) {
        updatesWindowFrame.origin.y += ([[updatesWindow contentView] frame].size.height * 0.25) + [view frame].size.height;
    }
    
    if ([view frame].size.height != [[updatesWindow contentView] frame].size.height) {
        [updatesWindow setFrame: updatesWindowFrame display: YES animate: YES];
    }
    
    [updatesWindow setTitle: title];
    
    NSDictionary *fadeAnimation = [NSDictionary dictionaryWithObjectsAndKeys: view, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil];
    NSArray *updatesWindowAnimations = [NSArray arrayWithObjects: fadeAnimation, nil];
    NSViewAnimation *updatesWindowAnimation = [[NSViewAnimation alloc] initWithViewAnimations: updatesWindowAnimations];
    
    [updatesWindow setContentView: view];
    
    [updatesWindowAnimation setAnimationBlockingMode: NSAnimationNonblockingThreaded];
    [updatesWindowAnimation startAnimation];
    
    [updatesWindowAnimation release];
}

#pragma mark -

- (void)displayCheckForUpdatesView {
    [self displayView: myCheckForUpdatesView inWindowWithTitle: @"Check for Updates"];
}

- (void)displayInstallUpdatesView {
    [self displayView: myInstallUpdatesView inWindowWithTitle: @"Install Updates"];
}

#pragma mark -

- (void)sparklerWillCheckForApplicationUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator startAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: NO];
}

#pragma mark -

- (void)sparklerDidFindApplicationUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
    
    [self displayInstallUpdatesView];
}

- (void)sparklerDidNotFindApplicationUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
}

@end
