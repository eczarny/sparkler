#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class SparklerApplicationUpdateManager, SparklerApplicationUpdatesDataSource, SparklerApplicationUpdatesWindowController;

@interface SparklerInstallUpdatesController : NSObject<NSTableViewDelegate> {
    SparklerApplicationUpdateManager *myApplicationUpdateManager;
    SparklerApplicationUpdatesDataSource *myUpdatesDataSource;
    IBOutlet SparklerApplicationUpdatesWindowController *myApplicationUpdatesWindowController;
    IBOutlet NSView *myInstallUpdatesView;
    IBOutlet NSTableView *myUpdatesTableView;
    IBOutlet WebView *myReleaseNotesWebView;
    IBOutlet NSButton *myUpdateErrorButton;
    IBOutlet NSTextField *myUpdateErrorTextField;
}

- (NSView *)installUpdatesView;

#pragma mark -

- (void)installUpdates: (id)sender;

@end
