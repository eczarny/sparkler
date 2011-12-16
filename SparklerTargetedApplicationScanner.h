#import <Cocoa/Cocoa.h>
#import "SparklerTargetedApplicationScannerDelegate.h"

@interface SparklerTargetedApplicationScanner : NSObject {
    id<SparklerTargetedApplicationScannerDelegate> myDelegate;
}

+ (SparklerTargetedApplicationScanner *)sharedScanner;

#pragma mark -

- (id<SparklerTargetedApplicationScannerDelegate>)delegate;

- (void)setDelegate: (id<SparklerTargetedApplicationScannerDelegate>)delegate;

#pragma mark -

- (void)scan;

@end
