#import <Cocoa/Cocoa.h>

@class SparklerUpdateEngine;

@protocol SparklerUpdateEngineDelegate

- (void)updateEngineWillCheckForApplicationUpdates: (SparklerUpdateEngine *)updateEngine;

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFindApplicationUpdates: (NSArray *)applicationUpdates;

- (void)updateEngineDidNotFindApplicationUpdates: (SparklerUpdateEngine *)updateEngine;

#pragma mark -

- (void)updateEngineWillDownloadApplicationUpdates: (SparklerUpdateEngine *)updateEngine;

- (void)updateEngineDidFinishDownloadingApplicationUpdates: (SparklerUpdateEngine *)updateEngine;

#pragma mark -

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFailWithError: (NSError *)error;

@end
