#import "SparklerGeneralPreferencePane.h"
#import "SparklerUtilities.h"

@implementation SparklerGeneralPreferencePane

- (void)preferencePaneDidLoad {
    
}

#pragma mark -

- (NSString *)name {
    return ZeroKitLocalizedString(@"General");
}

#pragma mark -

- (NSImage *)icon {
    return [SparklerUtilities imageFromResource: @"General Preferences" inBundle: [SparklerUtilities applicationBundle]];
}

#pragma mark -

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    return myView;
}

@end
