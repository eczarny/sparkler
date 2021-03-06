#import "SparklerGenericVersionComparatorTest.h"
#import "SparklerGenericVersionComparator.h"

@interface SparklerGenericVersionComparatorTest (SparklerGenericVersionComparatorTestPrivate)

- (void)assertOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB withExpectedResult: (NSComparisonResult)expectedResult;

#pragma mark -

- (void)assertAscendingOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB;

- (void)assertDescendingOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB;

- (void)assertSameOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB;

@end

#pragma mark -

@implementation SparklerGenericVersionComparatorTest

- (void)testGenericVersionComparison {
    [self assertSameOrderBetweenVersionA: @"1.0" andVersionB: @"1.0"];
    
    [self assertAscendingOrderBetweenVersionA: @"0.1" andVersionB: @"1.0"];
    [self assertAscendingOrderBetweenVersionA: @"1.0" andVersionB: @"1.9"];
    
    [self assertDescendingOrderBetweenVersionA: @"1.9" andVersionB: @"1.0"];
    [self assertDescendingOrderBetweenVersionA: @"1.0" andVersionB: @"0.1"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.0" andVersionB: @"1.0.1"];
    [self assertDescendingOrderBetweenVersionA: @"1.0.1" andVersionB: @"1.0"];
    
    [self assertSameOrderBetweenVersionA: @"1.0.0" andVersionB: @"1.0.0"];
    
    [self assertAscendingOrderBetweenVersionA: @"0.0.0" andVersionB: @"0.0.1"];
    [self assertAscendingOrderBetweenVersionA: @"0.0.1" andVersionB: @"0.1.1"];
    [self assertAscendingOrderBetweenVersionA: @"0.1.1" andVersionB: @"1.1.1"];
    
    [self assertDescendingOrderBetweenVersionA: @"1.1.1" andVersionB: @"0.1.1"];
    [self assertDescendingOrderBetweenVersionA: @"0.1.1" andVersionB: @"0.0.1"];
    [self assertDescendingOrderBetweenVersionA: @"0.0.1" andVersionB: @"0.0.0"];
}

- (void)testRevisionNumberComparison {
    [self assertSameOrderBetweenVersionA: @"8652" andVersionB: @"8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"8652" andVersionB: @"8653"];
    [self assertDescendingOrderBetweenVersionA: @"8653" andVersionB: @"8652"];
    
    [self assertSameOrderBetweenVersionA: @"r8652" andVersionB: @"r8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"r8652" andVersionB: @"r8653"];
    [self assertDescendingOrderBetweenVersionA: @"r8653" andVersionB: @"r8652"];
    
    [self assertSameOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2.3/8652"];
    [self assertSameOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2.3"];
    [self assertSameOrderBetweenVersionA: @"8652" andVersionB: @"1.2.3/8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"8653"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"8651"];
    
    [self assertSameOrderBetweenVersionA: @"1.2.3/r8652" andVersionB: @"1.2.3/r8652"];
    [self assertSameOrderBetweenVersionA: @"1.2.3/r8652" andVersionB: @"1.2.3"];
    [self assertSameOrderBetweenVersionA: @"r8652" andVersionB: @"1.2.3/r8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.2.3/r8652" andVersionB: @"r8653"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.3/r8652" andVersionB: @"r8651"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2.3/8653"];
    [self assertAscendingOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2.4/8652"];
    [self assertAscendingOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2.4/8653"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.3/8653" andVersionB: @"1.2.3/8652"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.4/8652" andVersionB: @"1.2.3/8652"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.4/8653" andVersionB: @"1.2.3/8652"];
    
    [self assertDescendingOrderBetweenVersionA: @"1.2.3" andVersionB: @"8651"];
    [self assertDescendingOrderBetweenVersionA: @"8651" andVersionB: @"1.2.3"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.2/8652" andVersionB: @"1.2.3/8652"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2/8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.2/8652" andVersionB: @"1.2.3/8653"];
    [self assertDescendingOrderBetweenVersionA: @"1.2.3/8653" andVersionB: @"1.2/8652"];
}

- (void)testPreReleaseVersionComparison {
    [self assertSameOrderBetweenVersionA: @"1.0a" andVersionB: @"1.0a"];
    [self assertSameOrderBetweenVersionA: @"1.0.0a" andVersionB: @"1.0.0a"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.0d" andVersionB: @"1.0a"];
    [self assertAscendingOrderBetweenVersionA: @"1.0a" andVersionB: @"1.0b"];
    [self assertAscendingOrderBetweenVersionA: @"1.0b" andVersionB: @"1.0"];
    [self assertAscendingOrderBetweenVersionA: @"1.0" andVersionB: @"1.1a"];
    [self assertDescendingOrderBetweenVersionA: @"1.1b" andVersionB: @"1.1a"];
    [self assertDescendingOrderBetweenVersionA: @"1.1a" andVersionB: @"1.0"];
    [self assertDescendingOrderBetweenVersionA: @"1.0" andVersionB: @"1.0b"];
    [self assertDescendingOrderBetweenVersionA: @"1.0b" andVersionB: @"1.0a"];
    [self assertDescendingOrderBetweenVersionA: @"1.0a" andVersionB: @"1.0d"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.0.0a" andVersionB: @"1.0.0b"];
    [self assertAscendingOrderBetweenVersionA: @"1.0.0b" andVersionB: @"1.0.0"];
    [self assertAscendingOrderBetweenVersionA: @"1.0.0" andVersionB: @"1.0.1a"];
    [self assertAscendingOrderBetweenVersionA: @"1.0.1b" andVersionB: @"1.1.0"];
    [self assertDescendingOrderBetweenVersionA: @"1.1.0" andVersionB: @"1.0.1b"];
    [self assertDescendingOrderBetweenVersionA: @"1.1.0b" andVersionB: @"1.0.0a"];
    
    [self assertSameOrderBetweenVersionA: @"1.0.0a/8652" andVersionB: @"1.0.0a/8652"];
    [self assertSameOrderBetweenVersionA: @"1.0.0a/8652" andVersionB: @"1.0.0a"];
    [self assertSameOrderBetweenVersionA: @"8652" andVersionB: @"1.0.0a/8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.0.0a/8652" andVersionB: @"8653"];
    [self assertAscendingOrderBetweenVersionA: @"1.0.0a/8652" andVersionB: @"1.0.0b/8652"];
    [self assertAscendingOrderBetweenVersionA: @"1.0.0b/8652" andVersionB: @"1.0.0/8652"];
    [self assertAscendingOrderBetweenVersionA: @"1.0.0/8652" andVersionB: @"1.0.0/8653"];
    [self assertDescendingOrderBetweenVersionA: @"1.0.0a/8652" andVersionB: @"8651"];
    [self assertDescendingOrderBetweenVersionA: @"1.0.0b/8652" andVersionB: @"1.0.0a/8652"];
    [self assertDescendingOrderBetweenVersionA: @"1.0.1b/8652" andVersionB: @"1.0.0/8652"];
}

@end

#pragma mark -

@implementation SparklerGenericVersionComparatorTest (SparklerGenericVersionComparatorTestPrivate)

- (void)assertOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB withExpectedResult: (NSComparisonResult)expectedResult {
    NSString *description;
    
    if (expectedResult == NSOrderedAscending) {
        description = @"Version %@ should be older than version %@.";
    } else if (expectedResult == NSOrderedDescending) {
        description = @"Version %@ should be newer than version %@.";
    } else {
        description = @"Version %@ and version %@ should be the same.";
    }
    
    STAssertTrue([SparklerGenericVersionComparator compareCurrentVersion: versionA toVersion: versionB] == expectedResult, description, versionA, versionB);
}

#pragma mark -

- (void)assertAscendingOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB {
    [self assertOrderBetweenVersionA: versionA andVersionB: versionB withExpectedResult: NSOrderedAscending];
}

- (void)assertDescendingOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB {
    [self assertOrderBetweenVersionA: versionA andVersionB: versionB withExpectedResult: NSOrderedDescending];
}

- (void)assertSameOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB {
    [self assertOrderBetweenVersionA: versionA andVersionB: versionB withExpectedResult: NSOrderedSame];
}

@end
