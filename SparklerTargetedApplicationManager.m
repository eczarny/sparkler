#import "SparklerTargetedApplicationManager.h"
#import "SparklerTargetedApplicationScanner.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerTargetedApplicationManager

static SparklerTargetedApplicationManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myTargetedApplications = nil;
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

+ (SparklerTargetedApplicationManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSArray *)targetedApplications {
    if (!myTargetedApplications) {
        [self synchronizeTargetedApplicationsWithFilesystem];
    }
    
    return myTargetedApplications;
}

- (void)setTargetedApplications: (NSArray *)targetedApplications {
    if (myTargetedApplications != targetedApplications) {
        [myTargetedApplications release];
        
        myTargetedApplications = [targetedApplications retain];
    }
}

#pragma mark -

- (void)rescanFilesystemForTargetedApplications {
    SparklerTargetedApplicationScanner *sharedApplicationScanner = [SparklerTargetedApplicationScanner sharedScanner];
    
    [sharedApplicationScanner setDelegate: self];
    
    NSLog(@"The targeted application manager is rescanning the filesystem.");
    
    [sharedApplicationScanner scan];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerApplicationsWillUpdateNotification object: self];
}

#pragma mark -

- (void)synchronizeTargetedApplicationsWithFilesystem {
    NSArray *targetedApplications = [SparklerUtilities targetedApplicationsFromFile: SparklerTargetedApplicationFile];
    
    if (!myTargetedApplications && targetedApplications) {
        [self setTargetedApplications: targetedApplications];
        
        NSLog(@"The targeted application manager found application metadata saved to disk.");
        
        return;
    } else if (!myTargetedApplications && !targetedApplications) {
        [self rescanFilesystemForTargetedApplications];
    } else {
        NSLog(@"The targeted application manager is saving the current application metadata to disk.");
        
        if (![SparklerUtilities saveTargetedApplications: myTargetedApplications toFile: SparklerTargetedApplicationFile]) {
            NSLog(@"Unable to save the application metadata to disk.");
        }
    }
}

#pragma mark -

- (void)dealloc {
    [myTargetedApplications release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Application Scanner Delegate Methods

#pragma mark -

- (void)applicationScannerDidFindTargetedApplications: (NSArray *)targetedApplications {
    [self setTargetedApplications: targetedApplications];
    
    [self synchronizeTargetedApplicationsWithFilesystem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerApplicationsDidUpdateNotification object: self];
}

- (void)applicationScannerDidNotFindTargetedApplications {
    NSLog(@"The application scanner failed to find any targetable applications.");
}

@end
