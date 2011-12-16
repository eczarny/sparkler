#import <Cocoa/Cocoa.h>
#import "SparklerUpdateDriverDelegate.h"
#import "SparklerUpdateEngineDelegate.h"

@class SparklerTargetedApplicationManager;

@interface SparklerUpdateEngine : NSObject<SparklerUpdateDriverDelegate> {
    SparklerTargetedApplicationManager *myTargetedApplicationManager;
    NSMutableDictionary *myTargetedApplications;
    NSMutableArray *myApplicationUpdates;
    id<SparklerUpdateEngineDelegate> myDelegate;
}

+ (SparklerUpdateEngine *)sharedEngine;

#pragma mark -

- (NSArray *)applicationUpdates;

#pragma mark -

- (id<SparklerUpdateEngineDelegate>)delegate;

- (void)setDelegate: (id<SparklerUpdateEngineDelegate>)delegate;

#pragma mark -

- (BOOL)isCheckingForUpdates;

#pragma mark -

- (void)checkForUpdates;

#pragma mark -

- (void)installUpdates;

@end
