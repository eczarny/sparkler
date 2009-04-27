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
#import "SparklerUpdateManager.h"
#import "SparklerConstants.h"

@interface SparklerUpdatesWindowController (SparklerUpdatesWindowControllerPrivate)

- (void)windowDidLoad;

#pragma mark -

- (void)prepareSparklerWindow;

#pragma mark -

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title;

#pragma mark -

- (void)displayCheckForUpdatesView;

- (void)displayInstallUpdatesView;

#pragma mark -

- (void)updateEngineWillCheckForUpdates: (NSNotification *)notification;

- (void)updateEngineDidFindUpdates: (NSNotification *)notification;

@end

#pragma mark -

@implementation SparklerUpdatesWindowController

static SparklerUpdatesWindowController *sharedInstance = nil;

- (id)init {
    if (self = [super initWithWindowNibName: SparklerUpdatesWindowNibName]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        myApplicationUpdateManager = [SparklerUpdateManager sharedManager];
        
        [notificationCenter addObserver: self
                               selector: @selector(updateEngineWillCheckForUpdates:)
                                   name: SparklerUpdateEngineWillCheckForUpdatesNotification
                                 object: nil];
        
        [notificationCenter addObserver: self
                               selector: @selector(updateEngineDidFindUpdates:)
                                   name: SparklerUpdateEngineDidFindUpdatesNotification
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
    [self prepareSparklerWindow];
}

#pragma mark -

- (void)prepareSparklerWindow {
    [[self window] center];
    
    [self displayCheckForUpdatesView];
}

#pragma mark -

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title {
    NSWindow *sparklerWindow = [self window];
    NSRect sparklerWindowFrame = [sparklerWindow frame];
    NSView *transitionView = [[NSView alloc] initWithFrame: [[sparklerWindow contentView] frame]];
    
    [sparklerWindow setContentView: transitionView];
    
    [transitionView release];
    
    sparklerWindowFrame.size.height = [view frame].size.height + ([sparklerWindow frame].size.height - [[sparklerWindow contentView] frame].size.height);
    sparklerWindowFrame.size.width = [view frame].size.width;
    sparklerWindowFrame.origin.y += ([[sparklerWindow contentView] frame].size.height - [view frame].size.height);
    
    [sparklerWindow setFrame: sparklerWindowFrame display: YES animate: YES];
    
    NSDictionary *checkForUpdatesViewAnimation = [NSDictionary dictionaryWithObjectsAndKeys: view, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil];
    NSArray *checkForUpdatesViewAnimations = [NSArray arrayWithObjects: checkForUpdatesViewAnimation, nil];
    NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations: checkForUpdatesViewAnimations];
    
    [sparklerWindow setContentView: view];
    
    [viewAnimation setAnimationBlockingMode: NSAnimationNonblockingThreaded];
    [viewAnimation startAnimation];
    
    [viewAnimation release];
    
    [sparklerWindow setShowsResizeIndicator: YES];
    
    [sparklerWindow setTitle: title];
}

#pragma mark -

- (void)displayCheckForUpdatesView {
    [self displayView: myCheckForUpdatesView inWindowWithTitle: @"Check for Updates"];
}

- (void)displayInstallUpdatesView {
    [self displayView: myInstallUpdatesView inWindowWithTitle: @"Install Updates"];
}

#pragma mark -

- (void)updateEngineWillCheckForUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator startAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: NO];
}

- (void)updateEngineDidFindUpdates: (NSNotification *)notification {
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
    
    [self displayInstallUpdatesView];
}

@end
