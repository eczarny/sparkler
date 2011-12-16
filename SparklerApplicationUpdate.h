#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>

@class SparklerTargetedApplication;

@interface SparklerApplicationUpdate : NSObject {
    SUAppcastItem *myAppcastItem;
    SparklerTargetedApplication *myTargetedApplication;
    BOOL isMarkedForInstallation;
}

- (id)initWithAppcastItem: (SUAppcastItem *)appcastItem targetedApplication: (SparklerTargetedApplication *)targetedApplication;

#pragma mark -

- (SUAppcastItem *)appcastItem;

- (void)setAppcastItem: (SUAppcastItem *)appcastItem;

#pragma mark -

- (SparklerTargetedApplication *)targetedApplication;

- (void)setTargetedApplication: (SparklerTargetedApplication *)targetedApplication;

#pragma mark -

- (BOOL)isMarkedForInstallation;

- (void)setMarkedForInstallation: (BOOL)markedForInstallation;

#pragma mark -

- (NSString *)targetVersion;

#pragma mark -

- (NSString *)installablePath;

@end
