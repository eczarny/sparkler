#import <Cocoa/Cocoa.h>

@interface SparklerTargetedApplication : NSObject<NSCoding> {
    NSString *myName;
    NSString *myPath;
    NSURL *myAppcastURL;
    NSImage *myIcon;
    BOOL isTargetedForUpdates;
}

- (id)initWithName: (NSString *)name path: (NSString *)path;

- (id)initWithCoder: (NSCoder*)coder;

#pragma mark -

- (void)encodeWithCoder: (NSCoder*)coder;

#pragma mark -

- (NSString *)name;

- (void)setName: (NSString *)name;

#pragma mark -

- (NSString *)version;

- (NSString *)displayVersion;

#pragma mark -

- (NSString *)path;

- (void)setPath: (NSString *)path;

#pragma mark -

- (NSURL *)appcastURL;

- (void)setAppcastURL: (NSURL *)appcastURL;

#pragma mark -

- (NSImage *)icon;

- (void)setIcon: (NSImage *)icon;

#pragma mark -

- (BOOL)isTargetedForUpdates;

- (void)setTargetedForUpdates: (BOOL)targetedForUpdates;

#pragma mark -

- (NSBundle *)applicationBundle;

#pragma mark -

- (NSComparisonResult)compareToVersion: (NSString *)version;

@end
