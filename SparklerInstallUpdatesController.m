#import "SparklerInstallUpdatesController.h"
#import "SparklerApplicationUpdateManager.h"
#import "SparklerApplicationUpdatesWindowController.h"
#import "SparklerApplicationUpdatesDataSource.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerInstallUpdatesController (SparklerInstallUpdatesControllerPrivate)

- (void)displayReleaseNotesFromApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate;

@end

#pragma mark -

@implementation SparklerInstallUpdatesController

- (void)awakeFromNib {
    myApplicationUpdateManager = [SparklerApplicationUpdateManager sharedManager];
    myUpdatesDataSource = [[SparklerApplicationUpdatesDataSource alloc] initWithTableView: myUpdatesTableView];
    
    [myUpdatesTableView setDelegate: self];
    [myUpdatesTableView setDataSource: myUpdatesDataSource];
}

#pragma mark -

- (NSView *)installUpdatesView {
    return myInstallUpdatesView;
}

#pragma mark -

- (void)installUpdates: (id)sender {
    [myApplicationUpdateManager installUpdates];
}

#pragma mark -

- (void)dealloc {
    [myUpdatesDataSource release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Table View Delegate Methods

#pragma mark -

- (BOOL)tableView: (NSTableView *)tableView shouldSelectRow: (NSInteger)rowIndex {
    SparklerApplicationUpdate *applicationUpdate = [[myApplicationUpdateManager applicationUpdates] objectAtIndex: rowIndex];
    
    if (applicationUpdate) {
        [self displayReleaseNotesFromApplicationUpdate: applicationUpdate];
    }
    
    return YES;
}

@end

#pragma mark -

@implementation SparklerInstallUpdatesController (SparklerInstallUpdatesControllerPrivate)

- (void)displayReleaseNotesFromApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate {
    SUAppcastItem *appcastItem = [applicationUpdate appcastItem];
    NSURL *releaseNotesURL = [appcastItem releaseNotesURL];
    WebFrame *releaseNotesWebFrame = [myReleaseNotesWebView mainFrame];
    
    if (releaseNotesURL) {
        NSURLRequest *releaseNotesRequest = [NSURLRequest requestWithURL: releaseNotesURL];
        
        [releaseNotesWebFrame loadRequest: releaseNotesRequest];
    } else {
        NSString *itemDescription = [appcastItem itemDescription];
        
        if (itemDescription) {
            [releaseNotesWebFrame loadHTMLString: itemDescription baseURL: nil];
        } else {
            NSString *releaseNotesNotFound = [SparklerUtilities stringFromBundledHTMLResource: SparklerReleaseNotesNotFoundFile];
            
            NSLog(@"There are no release notes available for %@.", [[applicationUpdate targetedApplication] name]);
            
            [releaseNotesWebFrame loadHTMLString: releaseNotesNotFound baseURL: nil];
        }
    }
}

@end
