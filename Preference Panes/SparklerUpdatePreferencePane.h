#import <Cocoa/Cocoa.h>

@interface SparklerUpdatePreferencePane : NSObject<ZeroKitPreferencePaneProtocol> {
    IBOutlet NSView *myView;
    IBOutlet NSButton *myCheckForUpdatesButton;
    IBOutlet SUUpdater *mySparkleUpdater;
}

- (NSString *)name;

#pragma mark -

- (NSImage *)icon;

#pragma mark -

- (NSString *)toolTip;

#pragma mark -

- (NSView *)view;

#pragma mark -

- (void)toggleCheckForUpdates: (id)sender;

@end
