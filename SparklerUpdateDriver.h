#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>
#import "SparklerUpdateDriverDelegate.h"

@class SparklerTargetedApplication, SparklerApplicationUpdate;

@interface SparklerUpdateDriver : NSObject {
    SparklerTargetedApplication *myTargetedApplication;
    SparklerApplicationUpdate *myApplicationUpdate;
    id<SparklerUpdateDriverDelegate> myDelegate;
}

- (id)initWithDelegate: (id<SparklerUpdateDriverDelegate>)delegate;

#pragma mark -

- (SparklerTargetedApplication *)targetedApplication;

#pragma mark -

- (SparklerApplicationUpdate *)applicationUpdate;

#pragma mark -

- (id<SparklerUpdateDriverDelegate>)delegate;

- (void)setDelegate: (id<SparklerUpdateDriverDelegate>)delegate;

#pragma mark -

- (void)checkTargetedApplicationForUpdates: (SparklerTargetedApplication *)targetedApplication;

#pragma mark -

- (void)installApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate;

#pragma mark -

- (void)abortUpdate;

@end
