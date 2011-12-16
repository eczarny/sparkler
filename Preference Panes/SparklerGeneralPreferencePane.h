#import <Cocoa/Cocoa.h>

@interface SparklerGeneralPreferencePane : NSObject<ZeroKitPreferencePaneProtocol> {
    IBOutlet NSView *myView;
}

- (NSString *)name;

#pragma mark -

- (NSImage *)icon;

#pragma mark -

- (NSString *)toolTip;

#pragma mark -

- (NSView *)view;

@end
