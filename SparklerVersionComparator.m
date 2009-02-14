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
// SparklerVersionComparator.m
// 
// Created by Eric Czarny on Friday, February 13, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerVersionComparator.h"

@interface SparklerVersionComparator (SparklerVersionComparatorPrivate)

+ (SparklerStringComponentType)typeFromStringComponent: (NSString *)stringComponent;

@end

#pragma mark -

@implementation SparklerVersionComparator

+ (NSComparisonResult)compareCurrentVersion: (NSString *)currentVersion toVersion: (NSString *)version {
    NSArray *currentVersionComponents = [currentVersion componentsSeparatedByString: @"."];
    NSArray *versionComponents = [version componentsSeparatedByString: @"."];
    NSInteger n = MIN([currentVersionComponents count], [versionComponents count]);
    NSInteger i;
    
    NSLog(@"Comparing version %@ to version %@.", currentVersion, version);
    
    for (i = 0; i < n; i++) {
        NSString *currentVersionComponent = [currentVersionComponents objectAtIndex: i];
        NSString *versionComponent = [versionComponents objectAtIndex: i];
        
        SparklerStringComponentType currentVersionComponentType = [SparklerVersionComparator typeFromStringComponent: currentVersionComponent];
        SparklerStringComponentType versionComponentType = [SparklerVersionComparator typeFromStringComponent: versionComponent];
        
        if (currentVersionComponentType == versionComponentType) {
            if (currentVersionComponentType == SparklerStringComponentTypeNumber) {
                NSInteger currentVersionComponentValue = [currentVersionComponent intValue];
                NSInteger versionComponentValue = [versionComponent intValue];
                
                if (currentVersionComponentValue > versionComponentValue) {
                    return NSOrderedDescending;
                } else if (currentVersionComponentValue < versionComponentValue) {
                    return NSOrderedAscending;
                }
            } else if (currentVersionComponentType == SparklerStringComponentTypeString) {
                NSComparisonResult comparisonResult = [currentVersionComponent compare: versionComponent];
                
                if (comparisonResult != NSOrderedSame) {
                    return comparisonResult;
                }
            }
        } else {
            if ((currentVersionComponentType != SparklerStringComponentTypeString) && (versionComponentType == SparklerStringComponentTypeString)) {
                return NSOrderedDescending;
            } else if ((currentVersionComponentType == SparklerStringComponentTypeString) && (versionComponentType != SparklerStringComponentTypeString)) {
                return NSOrderedAscending;
            } else {
                if (currentVersionComponentType == SparklerStringComponentTypeNumber) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }
        }
    }
    
    return NSOrderedSame;
}

@end

#pragma mark -

@implementation SparklerVersionComparator (SparklerVersionComparatorPrivate)

+ (SparklerStringComponentType)typeFromStringComponent: (NSString *)stringComponent {
    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember: [stringComponent characterAtIndex: 0]]) {
        return SparklerStringComponentTypeNumber;
    } else if ([[NSCharacterSet punctuationCharacterSet] characterIsMember: [stringComponent characterAtIndex: 0]]) {
        return SparklerStringComponentTypePunctuation;
    }
    
    return SparklerStringComponentTypeString;
}

@end
