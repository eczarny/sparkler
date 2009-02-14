// 
// Copyright (c) 2009 Eric Czarny <eczarny@gmail.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of  this  software  and  associated documentation files (the "Software"), to
// deal  in  the Software without restriction, including without limitation the
// rights  to  use,  copy,  modify,  merge,  publish,  distribute,  sublicense,
// and/or sell copies  of  the  Software,  and  to  permit  persons to whom the
// Software is furnished to do so, subject to the following conditions:
// 
// The  above  copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE  SOFTWARE  IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED,  INCLUDING  BUT  NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS  OR  COPYRIGHT  HOLDERS  BE  LIABLE  FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY,  WHETHER  IN  AN  ACTION  OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// 

// 
// Sparkler
// SparklerVersionComparatorTest.m
// 
// Created by Eric Czarny on Friday, February 13, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerVersionComparatorTest.h"
#import "SparklerVersionComparator.h"

@interface SparklerVersionComparatorTest (SparklerVersionComparatorTestPrivate)

- (void)assertOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB withExpectedResult: (NSComparisonResult)expectedResult;

#pragma mark -

- (void)assertAscendingOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB;

- (void)assertDescendingOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB;

- (void)assertSameOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB;

@end

#pragma mark -

@implementation SparklerVersionComparatorTest

- (void)testBasicVersionComparison {
    [self assertSameOrderBetweenVersionA: @"1.0" andVersionB: @"1.0"];
    
    [self assertAscendingOrderBetweenVersionA: @"0.1" andVersionB: @"1.0"];
    [self assertAscendingOrderBetweenVersionA: @"1.0" andVersionB: @"1.9"];
    
    [self assertDescendingOrderBetweenVersionA: @"1.9" andVersionB: @"1.0"];
    [self assertDescendingOrderBetweenVersionA: @"1.0" andVersionB: @"0.1"];
    
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
    [self assertAscendingOrderBetweenVersionA: @"8653" andVersionB: @"8663"];
    
    [self assertSameOrderBetweenVersionA: @"r8652" andVersionB: @"r8652"];
    
    [self assertAscendingOrderBetweenVersionA: @"r8652" andVersionB: @"r8653"];
    [self assertAscendingOrderBetweenVersionA: @"r8653" andVersionB: @"r8663"];
    
    [self assertSameOrderBetweenVersionA: @"1.2.3/8652" andVersionB: @"1.2.3/8652"];
}

- (void)testPreReleaseVersionComparison {
    [self assertSameOrderBetweenVersionA: @"1.0a" andVersionB: @"1.0a"];
    [self assertSameOrderBetweenVersionA: @"1.0.0b" andVersionB: @"1.0.0b"];
    
    [self assertAscendingOrderBetweenVersionA: @"1.0a" andVersionB: @"1.5b"];
}

#pragma mark -

- (void)testDivisibleByZeroVersionComparison {
    
}

@end

#pragma mark -

@implementation SparklerVersionComparatorTest (SparklerVersionComparatorTestPrivate)

- (void)assertOrderBetweenVersionA: (NSString *)versionA andVersionB: (NSString *)versionB withExpectedResult: (NSComparisonResult)expectedResult {
    NSString *description = @"";
    
    if (expectedResult == NSOrderedAscending) {
     description = @"Version %@ should be older than version %@.";
     } else if (expectedResult == NSOrderedDescending) {
     description = @"Version %@ should be newer than version %@.";
     } else {
     description = @"Version %@ and version %@ should be the same.";
     }
    
    STAssertTrue([SparklerVersionComparator compareCurrentVersion: versionA toVersion: versionB] == expectedResult, description, versionA, versionB);
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
