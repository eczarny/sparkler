#import "SparklerApplicationController.h"
#import "SparklerApplicationUpdatesWindowController.h"
#import "SparklerUtilities.h"

@implementation SparklerApplicationController

- (id)init {
    if (self = [super init]) {
        myPreferencesWindowController = [ZeroKitPreferencesWindowController sharedController];
    }
    
    return self;
}

#pragma mark -

- (void)applicationDidFinishLaunching: (NSNotification *)notification {
    [self toggleSparklerWindow: self];
}

#pragma mark -

- (void)togglePreferencesWindow: (id)sender {
    [myPreferencesWindowController togglePreferencesWindow: sender];
}

#pragma mark -

- (void)toggleSparklerWindow: (id)sender {
    [[SparklerApplicationUpdatesWindowController sharedController] toggleSparklerWindow: sender];
}

@end
