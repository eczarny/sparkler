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
// SparklerApplicationUpdatesWindowController.m
// 
// Created by Eric Czarny on Saturday, April 25, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerApplicationUpdatesWindowController.h"
#import "SparklerApplicationUpdateManager.h"
#import "SparklerApplicationUpdatesDataSource.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerApplicationUpdatesWindowController (SparklerApplicationUpdatesWindowControllerPrivate)

- (void)awakeFromNib;

#pragma mark -

- (void)displayView: (NSView *)view inWindowWithTitle: (NSString *)title;

#pragma mark -

- (void)displayCheckForUpdatesView;

- (void)displayInstallUpdatesView;

#pragma mark -

- (void)displayReleaseNotesFromApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate;

#pragma mark Update Engine Notifications

#pragma mark -

- (void)sparklerWillCheckForApplicationUpdates: (NSNotification *)notification;

#pragma mark -

- (void)sparklerDidFindApplicationUpdates: (NSNotification *)notification;

- (void)sparklerDidNotFindApplicationUpdates: (NSNotification *)notification;

@end

#pragma mark -

@implementation SparklerApplicationUpdatesWindowController

static SparklerApplicationUpdatesWindowController *sharedInstance = nil;

- (id)init {
    if (self = [super initWithWindowNibName: SparklerApplicationUpdatesWindowNibName]) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        myApplicationUpdateManager = [SparklerApplicationUpdateManager sharedManager];
        myUpdatesDataSource = [[SparklerApplicationUpdatesDataSource alloc] initWithTableView: myUpdatesTableView];
        
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

+ (SparklerApplicationUpdatesWindowController *)sharedController {
    if (!sharedInstance) {
        sharedInstance = [[SparklerApplicationUpdatesWindowController alloc] init];
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
    
    [myUpdatesDataSource release];
    
    [super dealloc];
}

#pragma mark Table View Delegate Methods

#pragma mark -

- (BOOL)tableView: (NSTableView *)tableView shouldSelectRow: (NSInteger)rowIndex {
    SparklerApplicationUpdate *applicationUpdate = [[myApplicationUpdateManager applicationUpdates] objectAtIndex: rowIndex];
    
    if (applicationUpdate) {
        [self displayReleaseNotesFromApplicationUpdate: applicationUpdate];
    }
    
    return YES;
}

@end

#pragma mark -

@implementation SparklerApplicationUpdatesWindowController (SparklerApplicationUpdatesWindowControllerPrivate)

- (void)awakeFromNib {
    NSWindow *sparklerWindow = [self window];
    
    [myUpdatesTableView setDelegate: self];
    [myUpdatesTableView setDataSource: myUpdatesDataSource];
    
    [sparklerWindow center];
    
    [self displayCheckForUpdatesView];
}

#pragma mark -

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

#pragma mark -

- (void)displayCheckForUpdatesView {
    [self displayView: myCheckForUpdatesView inWindowWithTitle: SparklerLocalizedString(@"Check for Updates")];
}

- (void)displayInstallUpdatesView {
    [self displayView: myInstallUpdatesView inWindowWithTitle: SparklerLocalizedString(@"Install Updates")];
}

#pragma mark -

- (void)displayReleaseNotesFromApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate {
    SUAppcastItem *appcastItem = [applicationUpdate appcastItem];
    NSURL *releaseNotesURL = [appcastItem releaseNotesURL];
    WebFrame *releaseNotesWebFrame = [myReleaseNotesWebView mainFrame];
    
    if (releaseNotesURL) {
        NSURLRequest *releaseNotesRequest = [NSURLRequest requestWithURL: releaseNotesURL];
        
        [releaseNotesWebFrame loadRequest: releaseNotesRequest];
    } else {
        NSString *itemDescription = [appcastItem itemDescription];
        
        if (itemDescription) {
            [releaseNotesWebFrame loadHTMLString: itemDescription baseURL: nil];
        } else {
            NSLog(@"There are no release notes available for %@.", [[applicationUpdate targetedApplication] name]);
        }
    }
}

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
    
    [self displayInstallUpdatesView];
}

- (void)sparklerDidNotFindApplicationUpdates: (NSNotification *)notification {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    
    [alert addButtonWithTitle: SparklerLocalizedString(@"OK")];
    
    [alert setMessageText: SparklerLocalizedString(@"There are no updates available.")];
    [alert setInformativeText: SparklerLocalizedString(@"Sparkler was unable to find an updates. Please try checking again later.")];
    
    [alert setAlertStyle: NSInformationalAlertStyle];
    
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
    
    [alert beginSheetModalForWindow: [self window] modalDelegate: self didEndSelector: NULL contextInfo: nil];
}

@end
