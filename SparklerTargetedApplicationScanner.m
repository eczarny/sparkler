#import "SparklerTargetedApplicationScanner.h"
#import "SparklerTargetedApplication.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerTargetedApplicationScanner (SparklerTargetedApplicationScannerPrivate)

- (void)scanForTargetedApplications;

#pragma mark -

- (NSArray *)scanForTargetedApplicationsAtSearchPath: (NSString *)searchPath;

#pragma mark -

- (void)loadIconsForTargetedApplications: (NSArray *)targetedApplications;

#pragma mark -

- (void)scannerDidFindTargetedApplications: (NSArray *)targetedApplications;

- (void)scannerDidNotFindTargetedApplications;

@end

#pragma mark -

@implementation SparklerTargetedApplicationScanner

static SparklerTargetedApplicationScanner *sharedInstance = nil;

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

+ (SparklerTargetedApplicationScanner *)sharedScanner {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (id<SparklerTargetedApplicationScannerDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SparklerTargetedApplicationScannerDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (void)scan {
    [NSThread detachNewThreadSelector: @selector(scanForTargetedApplications) toTarget: self withObject: nil];
}

@end

#pragma mark -

@implementation SparklerTargetedApplicationScanner (SparklerTargetedApplicationScannerPrivate)

- (void)scanForTargetedApplications {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSString *applicationsPath = [NSString stringWithString: SparklerApplicationsPath];
    NSArray *targetedApplications;
    
    NSLog(@"Initiating the scan for applications...");
    
    targetedApplications = [self scanForTargetedApplicationsAtSearchPath: applicationsPath];
    
    NSLog(@"The scan has completed. Sparkler found %d Sparkle-enabled application(s).", [targetedApplications count]);
    
    [self loadIconsForTargetedApplications: targetedApplications];
    
    [self scannerDidFindTargetedApplications: targetedApplications];
    
    [autoreleasePool release];
}

#pragma mark -

- (NSArray *)scanForTargetedApplicationsAtSearchPath: (NSString *)searchPath {
    NSArray *applicationsDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: searchPath error: nil];
    NSEnumerator *applicationsDirectoryEnumerator = [applicationsDirectory objectEnumerator];
    NSMutableArray *targetedApplications = [NSMutableArray array];
    NSArray *applicationBlacklist = [SparklerUtilities applicationBlacklist];
    NSString *path;
    
    while (path = [applicationsDirectoryEnumerator nextObject]) {
        path = [searchPath stringByAppendingPathComponent: path];
        
        if ([[path pathExtension] isEqualToString: SparklerApplicationBundleExtension]) {
            NSString *applicationName = [[path stringByDeletingPathExtension] lastPathComponent];
            NSString *applicationPath = [NSString stringWithString: path];
            NSBundle *applicationBundle = [NSBundle bundleWithPath: applicationPath];
            
            if ([applicationBlacklist containsObject: applicationName]) {
                NSLog(@"The application scanner found a blacklisted application: %@", applicationName);
                
                continue;
            }
            
            path = [path stringByAppendingPathComponent: SparklerApplicationContentsDirectory];
            path = [path stringByAppendingPathComponent: SparklerApplicationInfoFile];
            
            NSDictionary *applicationInformation = [[NSDictionary alloc] initWithContentsOfFile: path];
            NSString *applicationAppcastURL = [applicationBundle objectForInfoDictionaryKey: SparklerApplicationFeedURL];
            
            if (applicationAppcastURL) {
                SparklerTargetedApplication *targetedApplication = [[SparklerTargetedApplication alloc] initWithName: applicationName path: applicationPath];
                
                [targetedApplication setAppcastURL: [NSURL URLWithString: applicationAppcastURL]];
                
                [targetedApplications addObject: targetedApplication];
                
                [targetedApplication release];
            }
            
            [applicationInformation release];
        } else {
            [targetedApplications addObjectsFromArray: [self scanForTargetedApplicationsAtSearchPath: path]];
        }
    }
    
    return targetedApplications;
}

#pragma mark -

- (void)loadIconsForTargetedApplications: (NSArray *)targetedApplications {
    NSEnumerator *targetedApplicationsEnumerator = [targetedApplications objectEnumerator];
    id targetedApplication;
    
    while (targetedApplication = [targetedApplicationsEnumerator nextObject]) {
        NSImage *targetedApplicationIcon = [[NSWorkspace sharedWorkspace] iconForFile: [targetedApplication path]];
        
        if (targetedApplicationIcon) {
            [targetedApplication setIcon: targetedApplicationIcon];
        }
    }
}

#pragma mark -

- (void)scannerDidFindTargetedApplications: (NSArray *)targetedApplications {
    [myDelegate applicationScannerDidFindTargetedApplications: targetedApplications];
}

- (void)scannerDidNotFindTargetedApplications {
    [myDelegate applicationScannerDidNotFindTargetedApplications];
}

@end
