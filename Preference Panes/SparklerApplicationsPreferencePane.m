#import "SparklerApplicationsPreferencePane.h"
#import "SparklerApplicationsDataSource.h"
#import "SparklerTargetedApplicationManager.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationsPreferencePane

- (id)init {
    if (self = [super init]) {
        myApplicationsDataSource = [[SparklerApplicationsDataSource alloc] initWithTableView: myApplicationsTableView];
    }
    
    return self;
}

#pragma mark -

- (void)preferencePaneDidLoad {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(applicationsWillUpdate:)
                               name: SparklerApplicationsWillUpdateNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(applicationsDidUpdate:)
                               name: SparklerApplicationsDidUpdateNotification
                             object: nil];
    
    [[SparklerTargetedApplicationManager sharedManager] synchronizeTargetedApplicationsWithFilesystem];
    
    [myApplicationsTableView setDataSource: myApplicationsDataSource];
}

#pragma mark -

- (NSString *)name {
    return ZeroKitLocalizedString(@"Applications");
}

#pragma mark -

- (NSImage *)icon {
    return [SparklerUtilities imageFromResource: @"Application Preferences" inBundle: [SparklerUtilities applicationBundle]];
}

#pragma mark -

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    return myView;
}

#pragma mark -

- (void)refreshListOfApplications: (id)sender {
    SparklerTargetedApplicationManager *sharedTargetedApplicationManager = [SparklerTargetedApplicationManager sharedManager];
    
    [sharedTargetedApplicationManager rescanFilesystemForTargetedApplications];
}

#pragma mark -

- (void)viewHelpForPreferencePane: (id)sender {
    NSLog(@"viewHelpForPreferencePane:");
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [myApplicationsDataSource release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Application Scanner Notifications

#pragma mark -

- (void)applicationsWillUpdate: (NSNotification *)notification {
    [myScanningForApplicationsIndicator startAnimation: nil];
    
    [myRefreshApplicationsButton setEnabled: NO];
}

- (void)applicationsDidUpdate: (NSNotification *)notification {
    [myApplicationsTableView reloadData];
    
    [myScanningForApplicationsIndicator stopAnimation: nil];
    
    [myRefreshApplicationsButton setEnabled: YES];
}

@end
