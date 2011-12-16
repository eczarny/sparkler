#import <Cocoa/Cocoa.h>
#import "SparklerUpdateEngineDelegate.h"

@class SparklerUpdateEngine;

@interface SparklerApplicationUpdateManager : NSObject<SparklerUpdateEngineDelegate> {
    SparklerUpdateEngine *myUpdateEngine;
}

+ (SparklerApplicationUpdateManager *)sharedManager;

#pragma mark -

- (NSArray *)applicationUpdates;

#pragma mark -

- (void)checkForUpdates;

#pragma mark -

- (void)installUpdates;

@end
