#import "SparklerApplicationsDataSource.h"
#import "SparklerTargetedApplicationManager.h"
#import "SparklerTargetedApplication.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationsDataSource

- (id)initWithTableView: (NSTableView *)tableView {
    if (self = [super init]) {
        myTargetedApplicationManager = [SparklerTargetedApplicationManager sharedManager];
        myTableView = [tableView retain];
    }
    
    return self;
}

#pragma mark -

- (NSTableView *)tableView {
    return myTableView;
}

- (void)setTableView: (NSTableView *)tableView {
    if (myTableView != tableView) {
        [myTableView release];
        
        myTableView = [tableView retain];
    }
}

#pragma mark -

- (void)dealloc {
    [myTableView release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Table View Data Source Methods

#pragma mark -

- (NSInteger)numberOfRowsInTableView: (NSTableView *)tableView {
    return [[myTargetedApplicationManager targetedApplications] count];
}

- (id)tableView: (NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex {
    NSString *columnIdentifier = (NSString *)[tableColumn identifier];
    NSArray *targetedApplications = [myTargetedApplicationManager targetedApplications];
    SparklerTargetedApplication *targetedApplication = [targetedApplications objectAtIndex: rowIndex];
    id objectValue;
    
    if (!targetedApplication || !columnIdentifier) {
        return nil;
    }
    
    if ([columnIdentifier isEqualToString: SparklerApplicationSelectionField]) {
        if ([targetedApplication isTargetedForUpdates]) {
            objectValue = [NSNumber numberWithInt: NSOnState];
        } else {
            objectValue = [NSNumber numberWithInt: NSOffState];
        }
    } else if ([columnIdentifier isEqualToString: SparklerApplicationIconField]) {
        objectValue = [targetedApplication icon];
    } else if ([columnIdentifier isEqualToString: SparklerApplicationNameField]) {
        objectValue = [targetedApplication name];
    } else {
        objectValue = nil;
    }
    
    return objectValue;
}

- (void)tableView: (NSTableView *)tableView setObjectValue: (id)objectValue forTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex {
    NSString *columnIdentifier = (NSString *)[tableColumn identifier];
    NSArray *targetedApplications = [myTargetedApplicationManager targetedApplications];
    SparklerTargetedApplication *targetedApplication = [targetedApplications objectAtIndex: rowIndex];
    
    if ([columnIdentifier isEqualToString: SparklerApplicationSelectionField]) {
        [targetedApplication setTargetedForUpdates: [objectValue boolValue]];
    }
}

@end
