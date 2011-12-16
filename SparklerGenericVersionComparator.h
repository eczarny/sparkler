#import <Cocoa/Cocoa.h>
#import <RegexKit/RegexKit.h>
#import "SparklerVersionComparatorProtocol.h"

@interface SparklerGenericVersionComparator : NSObject<SparklerVersionComparatorProtocol> {
    
}

+ (NSComparisonResult)compareCurrentVersion: (NSString *)currentVersion toVersion: (NSString *)version;

@end
