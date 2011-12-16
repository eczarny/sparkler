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
    
    [alert addButtonWithTitle: ZeroKitLocalizedString(@"OK")];
    
    [alert setMessageText: ZeroKitLocalizedString(@"There are no updates available.")];
    [alert setInformativeText: ZeroKitLocalizedString(@"Sparkler was unable to find any updates. Please try checking again later.")];
    
    [alert setAlertStyle: NSInformationalAlertStyle];
    
    [myCheckForUpdatesIndicator stopAnimation: nil];
    
    [myCheckForUpdatesButton setEnabled: YES];
    
    [alert beginSheetModalForWindow: sparklerWindow modalDelegate: self didEndSelector: NULL contextInfo: nil];
}

@end
