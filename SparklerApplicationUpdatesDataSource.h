#import <Cocoa/Cocoa.h>

@class SparklerApplicationUpdateManager;

@interface SparklerApplicationUpdatesDataSource : NSObject<NSTableViewDataSource> {
    SparklerApplicationUpdateManager *myApplicationUpdateManager;
    NSTableView *myTableView;
}

- (id)initWithTableView: (NSTableView *)tableView;

#pragma mark -

- (NSTableView *)tableView;

- (void)setTableView: (NSTableView *)tableView;

@end
