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
// SparklerApplicationUpdatesWindowController.m
// 
// Created by Eric Czarny on Saturday, April 25, 2009.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerApplicationUpdatesWindowController.h"
#import "SparklerApplicationUpdateManager.h"
#import "SparklerCheckForUpdatesController.h"
#import "SparklerInstallUpdatesController.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerApplicationUpdatesWindowController (SparklerApplicationUpdatesWindowControllerPrivate)

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title;

@end

#pragma mark -

@implementation SparklerApplicationUpdatesWindowController

static SparklerApplicationUpdatesWindowController *sharedInstance = nil;

- (id)init {
    if (self = [super initWithWindowNibName: SparklerApplicationUpdatesWindowNibName]) {
        myApplicationUpdateManager = [SparklerApplicationUpdateManager sharedManager];
    }
    
    return self;
}

#pragma mark -

+ (SparklerApplicationUpdatesWindowController *)sharedController {
    if (!sharedInstance) {
        sharedInstance = [[SparklerApplicationUpdatesWindowController alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (void)awakeFromNib {
    NSWindow *sparklerWindow = [self window];
    
    [sparklerWindow center];
    
    [self displayCheckForUpdatesView];
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

- (void)displayCheckForUpdatesView {
    NSView *checkForUpdatesView = [myCheckForUpdatesController checkForUpdatesView];
    NSString *title = SparklerLocalizedString(@"Check for Updates");
    
    [self displayView: checkForUpdatesView inWindowWithTitle: title];
}

- (void)displayInstallUpdatesView {
    NSView *installUpdatesView = [myInstallUpdatesController installUpdatesView];
    NSString *title = SparklerLocalizedString(@"Install Updates");
    
    [self displayView: installUpdatesView inWindowWithTitle: title];
}

@end

#pragma mark -

@implementation SparklerApplicationUpdatesWindowController (SparklerApplicationUpdatesWindowControllerPrivate)

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title {
    NSWindow *sparklerWindow = [self window];
    NSView *transitionView = [[NSView alloc] initWithFrame: [[sparklerWindow contentView] frame]];
    NSRect sparklerWindowFrame = [sparklerWindow frame];
    
    [sparklerWindow setContentView: transitionView];
    
    [transitionView release];
    
    sparklerWindowFrame.size.height = [view frame].size.height + (sparklerWindowFrame.size.height - [[sparklerWindow contentView] frame].size.height);
    sparklerWindowFrame.size.width = [view frame].size.width;
    
    NSView *contentView = [sparklerWindow contentView];
    NSRect contentViewFrame = [contentView frame];
    
    if ([view frame].size.height > contentViewFrame.size.height) {
        sparklerWindowFrame.origin.y -= contentViewFrame.size.height + ([view frame].size.height * 0.25);
    } else if ([view frame].size.height < contentViewFrame.size.height) {
        sparklerWindowFrame.origin.y += (contentViewFrame.size.height * 0.25) + [view frame].size.height;
    }
    
    if ([view frame].size.height != contentViewFrame.size.height) {
        [sparklerWindow setFrame: sparklerWindowFrame display: YES animate: YES];
    }
    
    [sparklerWindow setTitle: title];
    
    NSDictionary *fadeAnimation = [NSDictionary dictionaryWithObjectsAndKeys: view, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil];
    NSArray *sparklerWindowAnimations = [NSArray arrayWithObjects: fadeAnimation, nil];
    NSViewAnimation *sparklerWindowAnimation = [[NSViewAnimation alloc] initWithViewAnimations: sparklerWindowAnimations];
    
    [sparklerWindow setContentView: view];
    
    [sparklerWindowAnimation setAnimationBlockingMode: NSAnimationNonblockingThreaded];
    [sparklerWindowAnimation startAnimation];
    
    [sparklerWindowAnimation release];
}

@end
