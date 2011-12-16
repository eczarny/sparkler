#import <Cocoa/Cocoa.h>

@protocol SparklerVersionComparatorProtocol

+ (NSComparisonResult)compareCurrentVersion: (NSString *)currentVersion toVersion: (NSString *)version;

@end
