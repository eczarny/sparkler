#import <Cocoa/Cocoa.h>

@class SparklerApplicationsDataSource;

@interface SparklerApplicationsPreferencePane : NSObject<ZeroKitPreferencePaneProtocol> {
    SparklerApplicationsDataSource *myApplicationsDataSource;
    IBOutlet NSView *myView;
    IBOutlet NSTableView *myApplicationsTableView;
    IBOutlet NSButton *myRefreshApplicationsButton;
    IBOutlet NSProgressIndicator *myScanningForApplicationsIndicator;
}

- (NSString *)name;

#pragma mark -

- (NSImage *)icon;

#pragma mark -

- (NSString *)toolTip;

#pragma mark -

- (NSView *)view;

#pragma mark -

- (void)refreshListOfApplications: (id)sender;

#pragma mark -

- (void)viewHelpForPreferencePane: (id)sender;

@end
