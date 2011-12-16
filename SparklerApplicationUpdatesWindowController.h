#import <Cocoa/Cocoa.h>

@class SparklerApplicationUpdateManager, SparklerCheckForUpdatesController, SparklerInstallUpdatesController;

@interface SparklerApplicationUpdatesWindowController : NSWindowController {
    SparklerApplicationUpdateManager *myApplicationUpdateManager;
    IBOutlet SparklerCheckForUpdatesController *myCheckForUpdatesController;
    IBOutlet SparklerInstallUpdatesController *myInstallUpdatesController;
}

+ (SparklerApplicationUpdatesWindowController *)sharedController;

#pragma mark -

- (void)showSparklerWindow: (id)sender;

- (void)hideSparklerWindow: (id)sender;

#pragma mark -

- (void)toggleSparklerWindow: (id)sender;

#pragma mark -

- (void)displayCheckForUpdatesView;

- (void)displayInstallUpdatesView;

@end
