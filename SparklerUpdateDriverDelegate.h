#import <Cocoa/Cocoa.h>

@class SparklerUpdateDriver, SparklerApplicationUpdate;

@protocol SparklerUpdateDriverDelegate

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFindApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate;

- (void)updateDriverDidNotFindApplicationUpdate: (SparklerUpdateDriver *)updateDriver;

#pragma mark -

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFinishDownloadingApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate;

#pragma mark -

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFailWithError: (NSError *)error;

@end
