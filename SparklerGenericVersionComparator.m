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
// SparklerGenericVersionComparator.m
// 
// Created by Eric Czarny on Friday, February 13, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerGenericVersionComparator.h"

typedef enum {
    SparklerStringComponentTypeNumber,
    SparklerStringComponentTypeString,
    SparklerStringComponentTypeVersionString
} SparklerStringComponentType;

#pragma mark -

@interface SparklerGenericVersionComparator (SparklerGenericVersionComparatorPrivate)

+ (SparklerStringComponentType)typeFromStringComponent: (NSString *)stringComponent;

#pragma mark -

+ (NSComparisonResult)compareVersion: (NSString *)version toVersionCompenents: (NSArray *)versionComponents forCurrentVersion: (BOOL)currentVersion;

+ (NSComparisonResult)compareCurrentVersionString: (NSString *)currentVersionString toVersionString: (NSString *)versionString;

@end

#pragma mark -

@implementation SparklerGenericVersionComparator

+ (NSComparisonResult)compareCurrentVersion: (NSString *)currentVersion toVersion: (NSString *)version {
    NSArray *currentVersionComponents = [currentVersion componentsSeparatedByString: @"/"];
    NSArray *versionComponents = [version componentsSeparatedByString: @"/"];
    
    if (([currentVersionComponents count] > 1) && ([versionComponents count] <= 1)) {
        return [SparklerGenericVersionComparator compareVersion: version toVersionCompenents: currentVersionComponents forCurrentVersion: NO];
    } else if (([currentVersionComponents count] <= 1) && ([versionComponents count] > 1)) {
        return [SparklerGenericVersionComparator compareVersion: currentVersion toVersionCompenents: versionComponents forCurrentVersion: YES];
    } else if (([currentVersionComponents count] > 1) && ([versionComponents count] > 1)) {
        NSComparisonResult comparisonResult = NSOrderedSame;
        NSInteger i;
        
        for (i = 0; i < [currentVersionComponents count]; i++) {
            NSString *currentVersionComponent = [currentVersionComponents objectAtIndex: i];
            
            comparisonResult = [SparklerGenericVersionComparator compareVersion: currentVersionComponent toVersionCompenents: versionComponents forCurrentVersion: YES];
            
            if (comparisonResult != NSOrderedSame) {
                break;
            }
        }
        
        return comparisonResult;
    }
    
    return [SparklerGenericVersionComparator compareCurrentVersionString: currentVersion toVersionString: version];
}

@end

#pragma mark -

@implementation SparklerGenericVersionComparator (SparklerGenericVersionComparatorPrivate)

+ (SparklerStringComponentType)typeFromStringComponent: (NSString *)stringComponent {
    if ([stringComponent isMatchedByRegex: @"^\\d+$"]) {
        return SparklerStringComponentTypeNumber;
    } else if ([stringComponent isMatchedByRegex: @"^\\d+\\.\\d+(\\.\\d+)*\\w*$"]) {
        return SparklerStringComponentTypeVersionString;
    }
    
    return SparklerStringComponentTypeString;
}

#pragma mark -

+ (NSComparisonResult)compareVersion: (NSString *)version toVersionCompenents: (NSArray *)versionComponents forCurrentVersion: (BOOL)currentVersion {
    NSComparisonResult comparisonResult = NSOrderedSame;
    NSInteger i;
    
    NSLog(@"Comparing version %@ to %d version components: %@", version, [versionComponents count], versionComponents);
    
    for (i = 0; i < [versionComponents count]; i++) {
        NSString *versionComponent = [versionComponents objectAtIndex: i];
        SparklerStringComponentType versionType = [SparklerGenericVersionComparator typeFromStringComponent: version];
        SparklerStringComponentType versionComponentType = [SparklerGenericVersionComparator typeFromStringComponent: versionComponent];
        
        if (versionType != versionComponentType) {
            NSLog(@"Skipping comparison between %@ and %@, as they are of differing types.", version, versionComponent);
            
            continue;
        }
        
        comparisonResult = [SparklerGenericVersionComparator compareCurrentVersionString: version toVersionString: versionComponent];
        
        if (!currentVersion) {
            if (comparisonResult == NSOrderedAscending) {
                comparisonResult = NSOrderedDescending;
            } else if (comparisonResult == NSOrderedDescending) {
                comparisonResult = NSOrderedAscending;
            }
        }
        
        if (comparisonResult != NSOrderedSame) {
            break;
        }
    }
    
    return comparisonResult;
}

+ (NSComparisonResult)compareCurrentVersionString: (NSString *)currentVersionString toVersionString: (NSString *)versionString {
    NSArray *currentVersionComponents = [currentVersionString componentsSeparatedByString: @"."];
    NSArray *versionComponents = [versionString componentsSeparatedByString: @"."];
    NSInteger i;
    
    NSLog(@"Comparing current version string %@ to version string %@.", currentVersionString, versionString);
    
    if ([SparklerGenericVersionComparator typeFromStringComponent: currentVersionString] != [SparklerGenericVersionComparator typeFromStringComponent: versionString]) {
        return NSOrderedDescending;
    }
    
    for (i = 0; i < MIN([currentVersionComponents count], [versionComponents count]); i++) {
        NSString *currentVersionComponent = [currentVersionComponents objectAtIndex: i];
        NSString *versionComponent = [versionComponents objectAtIndex: i];
        SparklerStringComponentType currentVersionComponentType = [SparklerGenericVersionComparator typeFromStringComponent: currentVersionComponent];
        SparklerStringComponentType versionComponentType = [SparklerGenericVersionComparator typeFromStringComponent: versionComponent];
        
        if (currentVersionComponentType == versionComponentType) {
            if (currentVersionComponentType == SparklerStringComponentTypeNumber) {
                NSInteger currentVersionComponentValue = [currentVersionComponent intValue];
                NSInteger versionComponentValue = [versionComponent intValue];
                
                NSLog(@"Comparing the number %d to the number %d.", currentVersionComponentValue, versionComponentValue);
                
                if (currentVersionComponentValue > versionComponentValue) {
                    return NSOrderedDescending;
                } else if (currentVersionComponentValue < versionComponentValue) {
                    return NSOrderedAscending;
                }
            } else if (currentVersionComponentType == SparklerStringComponentTypeString) {
                NSComparisonResult comparisonResult = [currentVersionComponent compare: versionComponent];
                
                NSLog(@"Comparing the string %@ to the string %@.", currentVersionComponent, versionComponent);
                
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
