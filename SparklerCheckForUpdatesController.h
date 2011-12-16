#import <Cocoa/Cocoa.h>

@class SparklerApplicationUpdateManager, SparklerApplicationUpdatesWindowController;

@interface SparklerCheckForUpdatesController : NSObject {
    SparklerApplicationUpdateManager *myApplicationUpdateManager;
    IBOutlet SparklerApplicationUpdatesWindowController *myApplicationUpdatesWindowController;
    IBOutlet NSView *myCheckForUpdatesView;
    IBOutlet NSButton *myCheckForUpdatesButton;
    IBOutlet NSProgressIndicator *myCheckForUpdatesIndicator;
}

- (NSView *)checkForUpdatesView;

#pragma mark -

- (void)checkForUpdates: (id)sender;

@end
