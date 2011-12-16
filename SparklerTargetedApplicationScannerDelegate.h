#import <Cocoa/Cocoa.h>

@protocol SparklerTargetedApplicationScannerDelegate

- (void)applicationScannerDidFindTargetedApplications: (NSArray *)targetedApplications;

- (void)applicationScannerDidNotFindTargetedApplications;

@end
