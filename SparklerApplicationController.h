#import <Cocoa/Cocoa.h>

@class ZeroKitPreferencesWindowController;

@interface SparklerApplicationController : NSObject {
    ZeroKitPreferencesWindowController *myPreferencesWindowController;
}

- (void)togglePreferencesWindow: (id)sender;

#pragma mark -

- (void)toggleSparklerWindow: (id)sender;

@end
