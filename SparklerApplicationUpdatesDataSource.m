#import "SparklerApplicationUpdatesDataSource.h"
#import "SparklerApplicationUpdateManager.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationUpdatesDataSource

- (id)initWithTableView: (NSTableView *)tableView {
    if (self = [super init]) {
        myApplicationUpdateManager = [SparklerApplicationUpdateManager sharedManager];
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
    return [[myApplicationUpdateManager applicationUpdates] count];
}

- (id)tableView: (NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex {
    NSString *columnIdentifier = (NSString *)[tableColumn identifier];
    NSArray *applicationUpdates = [myApplicationUpdateManager applicationUpdates];
    SparklerApplicationUpdate *applicationUpdate = [applicationUpdates objectAtIndex: rowIndex];
    SparklerTargetedApplication *targetedApplication;
    id objectValue;
    
    if (!applicationUpdate || !columnIdentifier) {
        return nil;
    }
    
    targetedApplication = [applicationUpdate targetedApplication];
    
    if ([columnIdentifier isEqualToString: SparklerApplicationUpdateSelectionField]) {
        if ([applicationUpdate isMarkedForInstallation]) {
            objectValue = [NSNumber numberWithInt: NSOnState];
        } else {
            objectValue = [NSNumber numberWithInt: NSOffState];
        }
    } else if ([columnIdentifier isEqualToString: SparklerApplicationIconField]) {
        objectValue = [targetedApplication icon];
    } else if ([columnIdentifier isEqualToString: SparklerApplicationNameField]) {
        objectValue = [targetedApplication name];
    } else if ([columnIdentifier isEqualToString: SparklerApplicationUpdateVersionField]) {
        objectValue = [applicationUpdate targetVersion];
    } else {
        objectValue = nil;
    }
    
    return objectValue;
}

- (void)tableView: (NSTableView *)tableView setObjectValue: (id)objectValue forTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex {
    NSString *columnIdentifier = (NSString *)[tableColumn identifier];
    NSArray *applicationUpdates = [myApplicationUpdateManager applicationUpdates];
    SparklerApplicationUpdate *applicationUpdate = [applicationUpdates objectAtIndex: rowIndex];
    
    if ([columnIdentifier isEqualToString: SparklerApplicationUpdateSelectionField]) {
        [applicationUpdate setMarkedForInstallation: [objectValue boolValue]];
    }
}

@end
