#import "SparklerUpdatePreferencePane.h"
#import "SparklerUtilities.h"

@implementation SparklerUpdatePreferencePane

- (void)preferencePaneDidLoad {
    if ([mySparkleUpdater automaticallyChecksForUpdates]) {
        [myCheckForUpdatesButton setState: NSOnState];
    } else {
        [myCheckForUpdatesButton setState: NSOffState];
    }
}

#pragma mark -

- (NSString *)name {
    return ZeroKitLocalizedString(@"Update");
}

#pragma mark -

- (NSImage *)icon {
    return [SparklerUtilities imageFromResource: @"Update Preferences" inBundle: [SparklerUtilities applicationBundle]];
}

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    return myView;
}

#pragma mark -

- (void)toggleCheckForUpdates: (id)sender {
    [mySparkleUpdater setAutomaticallyChecksForUpdates: ![mySparkleUpdater automaticallyChecksForUpdates]];
}

@end
