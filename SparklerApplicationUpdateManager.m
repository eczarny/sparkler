#import "SparklerApplicationUpdateManager.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerUpdateEngine.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationUpdateManager

static SparklerApplicationUpdateManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myUpdateEngine = [SparklerUpdateEngine sharedEngine];
        
        [myUpdateEngine setDelegate: self];
    }
    
    return self;
}

#pragma mark -

+ (id)allocWithZone: (NSZone *)zone {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone: zone];
            
            return sharedInstance;
        }
    }
    
    return nil;
}

#pragma mark -

+ (SparklerApplicationUpdateManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSArray *)applicationUpdates {
    return [myUpdateEngine applicationUpdates];
}

#pragma mark -

- (void)checkForUpdates {
    [myUpdateEngine checkForUpdates];
}

#pragma mark -

- (void)installUpdates {
    [myUpdateEngine installUpdates];
}

#pragma mark -

#pragma mark Update Engine Delegate Methods

#pragma mark -

- (void)updateEngineWillCheckForApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler is checking for updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerWillCheckForApplicationUpdatesNotification object: self];
}

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFindApplicationUpdates: (NSArray *)applicationUpdates {
    NSLog(@"Sparkler found updates for %d application(s).", [applicationUpdates count]);
    
    [[NSApplication sharedApplication] requestUserAttention: NSInformationalRequest];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerDidFindApplicationUpdatesNotification object: self];
}

- (void)updateEngineDidNotFindApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler did not find any updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerDidNotFindApplicationUpdatesNotification object: self];
}

#pragma mark -

- (void)updateEngineWillDownloadApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler will download the selected updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerWillDownloadApplicationUpdatesNotification object: self];
}

- (void)updateEngineDidFinishDownloadingApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler finished downloading the selected updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerDidDownloadApplicationUpdatesNotification object: self];
}

#pragma mark -

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFailWithError: (NSError *)error {
    NSLog(@"Sparkler failed checking for updates with error: %@", [error localizedDescription]);
}

@end
