#import <Cocoa/Cocoa.h>

@class SparklerTargetedApplicationManager;

@interface SparklerApplicationsDataSource : NSObject<NSTableViewDataSource> {
    SparklerTargetedApplicationManager *myTargetedApplicationManager;
    NSTableView *myTableView;
}

- (id)initWithTableView: (NSTableView *)tableView;

#pragma mark -

- (NSTableView *)tableView;

- (void)setTableView: (NSTableView *)tableView;

@end
