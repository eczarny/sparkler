#import <Cocoa/Cocoa.h>
#import "SparklerTargetedApplicationScannerDelegate.h"

@interface SparklerTargetedApplicationManager : NSObject<SparklerTargetedApplicationScannerDelegate> {
    NSArray *myTargetedApplications;
}

+ (SparklerTargetedApplicationManager *)sharedManager;

#pragma mark -

- (NSArray *)targetedApplications;

- (void)setTargetedApplications: (NSArray *)targetedApplications;

#pragma mark -

- (void)rescanFilesystemForTargetedApplications;

#pragma mark -

- (void)synchronizeTargetedApplicationsWithFilesystem;

@end
