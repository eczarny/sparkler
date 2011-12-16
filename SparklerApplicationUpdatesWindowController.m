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
    NSString *title = ZeroKitLocalizedString(@"Check for Updates");
    
    [self displayView: checkForUpdatesView inWindowWithTitle: title];
}

- (void)displayInstallUpdatesView {
    NSView *installUpdatesView = [myInstallUpdatesController installUpdatesView];
    NSString *title = ZeroKitLocalizedString(@"Install Updates");
    
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
