#import "SparklerApplicationUpdate.h"
#import "SparklerTargetedApplication.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationUpdate

- (id)initWithAppcastItem: (SUAppcastItem *)appcastItem targetedApplication: (SparklerTargetedApplication *)targetedApplication {
    if (self = [super init]) {
        myAppcastItem = [appcastItem retain];
        myTargetedApplication = [targetedApplication retain];
        isMarkedForInstallation = NO;
    }
    
    return self;
}

#pragma mark -

- (SUAppcastItem *)appcastItem {
    return myAppcastItem;
}

- (void)setAppcastItem: (SUAppcastItem *)appcastItem {
    if (myAppcastItem != appcastItem) {
        [myAppcastItem release];
        
        myAppcastItem = [appcastItem retain];
    }
}

#pragma mark -

- (SparklerTargetedApplication *)targetedApplication {
    return myTargetedApplication;
}

- (void)setTargetedApplication: (SparklerTargetedApplication *)targetedApplication {
    if (myTargetedApplication != targetedApplication) {
        [myTargetedApplication release];
        
        myTargetedApplication = [targetedApplication retain];
    }
}

#pragma mark -

- (BOOL)isMarkedForInstallation {
    return isMarkedForInstallation;
}

- (void)setMarkedForInstallation: (BOOL)markedForInstallation {
    isMarkedForInstallation = markedForInstallation;
}

#pragma mark -

- (NSString *)installablePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportPath = [SparklerUtilities applicationSupportPathForBundle: [SparklerUtilities applicationBundle]];
    NSString *downloadPath = [applicationSupportPath stringByAppendingPathComponent: SparklerDownloadsDirectory];
    NSString *fileExtension;
    NSString *filename;
    BOOL isDirectory;
    
    if (![fileManager fileExistsAtPath: downloadPath isDirectory: &isDirectory] && isDirectory) {
        if (![fileManager createDirectoryAtPath: downloadPath withIntermediateDirectories: NO attributes: nil error: nil]) {
            NSLog(@"There was a problem creating the download directory at path: %@", downloadPath);
            
            return nil;
        }
    }
    
    fileExtension = [[[myAppcastItem fileURL] absoluteString] pathExtension];
    filename = [NSString stringWithFormat: @"%@ %@.%@", [myTargetedApplication name], [self targetVersion], fileExtension];
    
    return [downloadPath stringByAppendingPathComponent: filename];
}

#pragma mark -

- (NSString *)targetVersion {
    return [myAppcastItem displayVersionString];
}

#pragma mark -

- (void)dealloc {
    [myAppcastItem release];
    [myTargetedApplication release];
    
    [super dealloc];
}

@end
