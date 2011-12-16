#import "SparklerUpdateEngine.h"
#import "SparklerTargetedApplicationManager.h"
#import "SparklerTargetedApplication.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerUpdateDriver.h"

@interface SparklerUpdateEngine (SparklerUpdateEnginePrivate)

- (void)updateDriverDidRespond: (SparklerUpdateDriver *)updateDriver;

@end

#pragma mark -

@implementation SparklerUpdateEngine

static SparklerUpdateEngine *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myTargetedApplicationManager = [SparklerTargetedApplicationManager sharedManager];
        myTargetedApplications = [[NSMutableDictionary alloc] init];
        myApplicationUpdates = [[NSMutableArray alloc] init];
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

+ (SparklerUpdateEngine *)sharedEngine {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSArray *)applicationUpdates {
    return myApplicationUpdates;
}

#pragma mark -

- (id<SparklerUpdateEngineDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SparklerUpdateEngineDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (BOOL)isCheckingForUpdates {
    if ([myTargetedApplications count] > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (void)checkForUpdates {
    NSArray *targetedApplications = [myTargetedApplicationManager targetedApplications];
    NSEnumerator *targetedApplicationsEnumerator = [targetedApplications objectEnumerator];
    SparklerTargetedApplication *targetedApplication;
    
    if ([self isCheckingForUpdates]) {
        NSLog(@"The update engine is already checking for updates.");
        
        return;
    }
    
    [myDelegate updateEngineWillCheckForApplicationUpdates: self];
    
    [myTargetedApplications removeAllObjects];
    [myApplicationUpdates removeAllObjects];
    
    while (targetedApplication = [targetedApplicationsEnumerator nextObject]) {
        if ([targetedApplication isTargetedForUpdates]) {
            SparklerUpdateDriver *updateDriver = [[SparklerUpdateDriver alloc] initWithDelegate: self];
            
            [myTargetedApplications setObject: targetedApplication forKey: [targetedApplication name]];
            
            [updateDriver checkTargetedApplicationForUpdates: targetedApplication];
        }
    }
}

#pragma mark -

- (void)installUpdates {
    NSEnumerator *applicationUpdatesEnumerator = [myApplicationUpdates objectEnumerator];
    SparklerApplicationUpdate *applicationUpdate;
    
    while (applicationUpdate = [applicationUpdatesEnumerator nextObject]) {
        if ([applicationUpdate isMarkedForInstallation]) {
            SparklerUpdateDriver *updateDriver = [[SparklerUpdateDriver alloc] initWithDelegate: self];
            
            [updateDriver installApplicationUpdate: applicationUpdate];
        }
    }
}

#pragma mark -

- (void)dealloc {
    [myTargetedApplications release];
    [myApplicationUpdates release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Update Driver Delegate Methods

#pragma mark -

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFindApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate {
    NSLog(@"Sparkler found a new update for %@.", [[updateDriver targetedApplication] name]);
    
    [myApplicationUpdates addObject: applicationUpdate];
    
    [self updateDriverDidRespond: updateDriver];
}

- (void)updateDriverDidNotFindApplicationUpdate: (SparklerUpdateDriver *)updateDriver {
    NSLog(@"Sparkler did not find a new update for %@.", [[updateDriver targetedApplication] name]);
    
    [self updateDriverDidRespond: updateDriver];
}

#pragma mark -

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFinishDownloadingApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate {
    NSLog(@"The update for %@ has been downloaded.", [[updateDriver targetedApplication] name]);
}

#pragma mark -

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFailWithError: (NSError *)error {
    NSLog(@"The update for %@ failed with error: %@", [[updateDriver targetedApplication] name], [error localizedDescription]);
    
    [self updateDriverDidRespond: updateDriver];
}

@end

#pragma mark -

@implementation SparklerUpdateEngine (SparklerUpdateEnginePrivate)

- (void)updateDriverDidRespond: (SparklerUpdateDriver *)updateDriver {
    [myTargetedApplications removeObjectForKey: [[updateDriver targetedApplication] name]];
    
    if (![self isCheckingForUpdates]) {
        if ([myApplicationUpdates count] > 0) {
            [myDelegate updateEngine: self didFindApplicationUpdates: myApplicationUpdates];
        } else {
            [myDelegate updateEngineDidNotFindApplicationUpdates: self];
        }
    }
    
    [updateDriver release];
}

@end
