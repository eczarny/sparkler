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
// SparklerPreferencesWindowController.m
// 
// Created by Eric Czarny on Friday, December 12, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerPreferencesWindowController.h"
#import "SparklerPreferencePaneManager.h"
#import "SparklerPreferencePaneProtocol.h"
#import "SparklerConstants.h"

@interface SparklerPreferencesWindowController (SparklerPreferencesWindowControllerPrivate)

- (void)windowDidLoad;

#pragma mark -

- (id<SparklerPreferencePaneProtocol>)preferencePaneWithName: (NSString *)name;

- (void)displayPreferencePaneWithName: (NSString *)name initialPreferencePane: (BOOL)initialPreferencePane;

#pragma mark -

- (void)preparePreferencesWindow;

#pragma mark -

- (void)createToolbar;

#pragma mark -

- (void)toolbarItemWasSelected: (NSToolbarItem *)toolbarItem;

@end

#pragma mark -

@interface SparklerPreferencesWindowController (SparklerPreferencesWindowControllerToolbarDelegate)

- (NSArray *)toolbarAllowedItemIdentifiers: (NSToolbar *)toolbar;

- (NSArray *)toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar;

- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar;

- (NSToolbarItem *)toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *)itemIdentifier willBeInsertedIntoToolbar: (BOOL)flag;

@end

#pragma mark -

@implementation SparklerPreferencesWindowController

static SparklerPreferencesWindowController *sharedInstance = nil;

- (id)init {
    if (self = [super initWithWindowNibName: SparklerPreferencesWindowNibName]) {
        myToolbarItems = [[NSMutableDictionary alloc] init];
        myPreferencePaneManager = [SparklerPreferencePaneManager sharedManager];
    }
    
    return self;
}

#pragma mark -

+ (SparklerPreferencesWindowController *)sharedController {
    if (!sharedInstance) {
        sharedInstance = [[SparklerPreferencesWindowController alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (void)showPreferencesWindow {
    [[self window] makeKeyAndOrderFront: nil];
}

- (void)hidePreferencesWindow {
    [[self window] performClose: nil];
}

#pragma mark -

- (void)togglePreferencesWindow {
    if ([[self window] isKeyWindow]) {
        [self hidePreferencesWindow];
    } else {
        [self showPreferencesWindow];
    }
}

#pragma mark -

- (void)loadPreferencePanes {
    [myPreferencePaneManager loadPreferencePanes];
}

#pragma mark -

- (NSArray *)loadedPreferencePanes {
    if (![myPreferencePaneManager preferencePanesAreReady]) {
        [myPreferencePaneManager loadPreferencePanes];
    }
    
    return [myPreferencePaneManager preferencePanes];
}

#pragma mark -

- (void)dealloc {
    [myToolbar release];
    [myToolbarItems release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SparklerPreferencesWindowController (SparklerPreferencesWindowControllerPrivate)

- (void)windowDidLoad {
    if (!myToolbar) {
        [self createToolbar];
    }
    
    [self preparePreferencesWindow];
}

#pragma mark -

- (id<SparklerPreferencePaneProtocol>)preferencePaneWithName: (NSString *)name {
    return [myPreferencePaneManager preferencePaneWithName: name];
}

- (void)displayPreferencePaneWithName: (NSString *)name initialPreferencePane: (BOOL)initialPreferencePane {
    id<SparklerPreferencePaneProtocol> preferencePane = [self preferencePaneWithName: name];
    
    NSLog(@"Displaying the %@ preference pane.", name);
    
    if (preferencePane) {
        NSWindow *preferencesWindow = [self window];
        NSView *preferencePaneView = [preferencePane view];
        NSRect preferencesWindowFrame = [preferencesWindow frame];
        NSView *transitionView = [[NSView alloc] initWithFrame: [[preferencesWindow contentView] frame]];
        
        [preferencesWindow setContentView: transitionView];
        
        [transitionView release]; 
        
        preferencesWindowFrame.size.height = [preferencePaneView frame].size.height + ([preferencesWindow frame].size.height - [[preferencesWindow contentView] frame].size.height);
        preferencesWindowFrame.size.width = [preferencePaneView frame].size.width;
        preferencesWindowFrame.origin.y += ([[preferencesWindow contentView] frame].size.height - [preferencePaneView frame].size.height);
        
        [preferencesWindow setFrame: preferencesWindowFrame display: YES animate: YES];
        
        NSDictionary *preferencePaneViewAnimation = [NSDictionary dictionaryWithObjectsAndKeys: preferencePaneView, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil];
        NSArray *preferencePaneViewAnimations = [NSArray arrayWithObjects: preferencePaneViewAnimation, nil];
        NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations: preferencePaneViewAnimations];
        
        [preferencesWindow setContentView: preferencePaneView];
        
        if (!initialPreferencePane) {
            [viewAnimation setAnimationBlockingMode: NSAnimationNonblockingThreaded];
            [viewAnimation startAnimation];
        }
        
        [viewAnimation release];
        
        [preferencesWindow setShowsResizeIndicator: YES];
        
        if (myToolbarItems && ([myToolbarItems count] > 0)) {
            [preferencesWindow setTitle: name];
        }
        
        [myToolbar setSelectedItemIdentifier: name];
    } else {
        NSLog(@"Unable to locate a preference pane with the name: %@", name);
    }
}

#pragma mark -

- (void)preparePreferencesWindow {
    NSArray *preferencePanes = [myPreferencePaneManager preferencePanes];
    id<SparklerPreferencePaneProtocol> preferencePane = [preferencePanes objectAtIndex: 0];
    
    if (!preferencePanes || !preferencePane) {
        NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey: SparklerApplicationBundleName];
        
        NSRunAlertPanel(@"Preferences", [NSString stringWithFormat: @"Preferences are not available for %@.", applicationName], @"OK", nil, nil);
    }
    
    [self displayPreferencePaneWithName: [preferencePane name] initialPreferencePane: YES];
    
    [[self window] center];
}

#pragma mark -

- (void)createToolbar {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *preferencePanes = [myPreferencePaneManager preferencePanes];
    NSEnumerator *preferencePaneEnumerator = [preferencePanes objectEnumerator];
    id<SparklerPreferencePaneProtocol> preferencePane;
    
    while (preferencePane = [preferencePaneEnumerator nextObject]) {
        NSString *preferencePaneName = [preferencePane name];
        NSString *preferencePaneToolTip = [preferencePane toolTip];
        NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier: preferencePaneName];
        
        [toolbarItem setLabel: preferencePaneName];
        [toolbarItem setImage: [preferencePane icon]];
        
        if (preferencePaneToolTip && ![preferencePaneToolTip isEqualToString: @""]) {
            [toolbarItem setToolTip: preferencePaneToolTip];
        } else {
            [toolbarItem setToolTip: nil];
        }
        
        [toolbarItem setTarget: self];
        [toolbarItem setAction: @selector(toolbarItemWasSelected:)];
        
        [myToolbarItems setObject: toolbarItem forKey: preferencePaneName];
        
        [toolbarItem release];
    }
    
    myToolbar = [[NSToolbar alloc] initWithIdentifier: bundleIdentifier];
    
    [myToolbar setDelegate: self];
    [myToolbar setAllowsUserCustomization: NO];
    [myToolbar setAutosavesConfiguration: NO];
    
    if (myToolbarItems && ([myToolbarItems count] > 0)) {
        [[self window] setToolbar: myToolbar];
    } else {
        NSLog(@"No toolbar items were found, the preferences window will not display a toolbar.");
    }
}

#pragma mark -

- (void)toolbarItemWasSelected: (NSToolbarItem *)toolbarItem {
    NSString *toolbarItemIdentifier = [toolbarItem itemIdentifier];
    
    if (![toolbarItemIdentifier isEqualToString: [[self window] title]]) {
        [self displayPreferencePaneWithName: toolbarItemIdentifier initialPreferencePane: NO];
    }
}

@end

#pragma mark -

@implementation SparklerPreferencesWindowController (SparklerPreferencesWindowControllerToolbarDelegate)

- (NSArray *)toolbarAllowedItemIdentifiers: (NSToolbar *)toolbar {
    return [myPreferencePaneManager preferencePaneOrder];
}

- (NSArray *)toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar {
    return [myPreferencePaneManager preferencePaneOrder];
}

- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar {
    return [myPreferencePaneManager preferencePaneOrder];
}

- (NSToolbarItem *)toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *)itemIdentifier willBeInsertedIntoToolbar: (BOOL)flag {
    return [myToolbarItems objectForKey: itemIdentifier];
}

@end
