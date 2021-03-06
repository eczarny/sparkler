#import "SparklerGenericVersionComparator.h"

typedef enum {
    SparklerStringComponentTypeNumber,
    SparklerStringComponentTypeString,
    SparklerStringComponentTypeVersionString,
    SparklerStringComponentTypePreReleaseVersionString
} SparklerStringComponentType;

#pragma mark -

#define SparklerPreReleaseDevelopmentModifier         @"d"
#define SparklerPreReleaseAlphaModifier               @"a"
#define SparklerPreReleaseBetaModifier                @"b"

#pragma mark -

#define SparklerVersionStringComponentRegex           @"^\\d+\\.\\d+(\\.\\d+)*\\w*$"
#define SparklerVersionNumberComponentRegex           @"^\\d+$"
#define SparklerPreReleaseVersionStringComponentRegex @"^\\d+\\w$"

#define SparklerPreReleaseVersionComponentRegex       @"^(\\d+)(\\w)$"

#pragma mark -

@interface SparklerGenericVersionComparator (SparklerGenericVersionComparatorPrivate)

+ (SparklerStringComponentType)typeFromStringComponent: (NSString *)stringComponent;

#pragma mark -

+ (NSComparisonResult)compareVersion: (NSString *)version toVersionCompenents: (NSArray *)versionComponents forCurrentVersion: (BOOL)currentVersion;

+ (NSComparisonResult)compareCurrentVersionString: (NSString *)currentVersionString toVersionString: (NSString *)versionString;

#pragma mark -

+ (NSComparisonResult)compareCurrentPreReleaseVersionComponent: (NSString *)currentPreReleaseVersionComponent toPreReleaseVersionComponent: (NSString *)preReleaseVersionComponent;

#pragma mark -

+ (NSComparisonResult)comparePreReleaseVersionComponent: (NSString *)preReleaseVersionComponent toVersionComponent: (NSString *)versionComponent;

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
    if ([stringComponent isMatchedByRegex: SparklerVersionStringComponentRegex]) {
        return SparklerStringComponentTypeVersionString;
    } else if ([stringComponent isMatchedByRegex: SparklerVersionNumberComponentRegex]) {
        return SparklerStringComponentTypeNumber;
    } else if ([stringComponent isMatchedByRegex: SparklerPreReleaseVersionStringComponentRegex]) {
        return SparklerStringComponentTypePreReleaseVersionString;
    }
    
    return SparklerStringComponentTypeString;
}

#pragma mark -

+ (NSComparisonResult)compareVersion: (NSString *)version toVersionCompenents: (NSArray *)versionComponents forCurrentVersion: (BOOL)currentVersion {
    NSComparisonResult comparisonResult = NSOrderedSame;
    NSInteger i;
    
    for (i = 0; i < [versionComponents count]; i++) {
        NSString *versionComponent = [versionComponents objectAtIndex: i];
        SparklerStringComponentType versionType = [SparklerGenericVersionComparator typeFromStringComponent: version];
        SparklerStringComponentType versionComponentType = [SparklerGenericVersionComparator typeFromStringComponent: versionComponent];
        
        if (versionType != versionComponentType) {
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
            } else if (currentVersionComponentType == SparklerStringComponentTypePreReleaseVersionString) {
                return [SparklerGenericVersionComparator compareCurrentPreReleaseVersionComponent: currentVersionComponent toPreReleaseVersionComponent: versionComponent];
            }
        } else {
            if (currentVersionComponentType == SparklerStringComponentTypePreReleaseVersionString) {
                return [SparklerGenericVersionComparator comparePreReleaseVersionComponent: currentVersionComponent toVersionComponent: versionComponent];
            } else if (versionComponentType == SparklerStringComponentTypePreReleaseVersionString) {
                NSComparisonResult comparisonResult = [SparklerGenericVersionComparator comparePreReleaseVersionComponent: versionComponent toVersionComponent: currentVersionComponent];
                
                if (comparisonResult == NSOrderedAscending) {
                    return NSOrderedDescending;
                } else if (comparisonResult == NSOrderedDescending) {
                    return NSOrderedAscending;
                }
            }
            
            if ((currentVersionComponentType != SparklerStringComponentTypeString) && (versionComponentType == SparklerStringComponentTypeString)) {
                return NSOrderedAscending;
            } else if ((currentVersionComponentType == SparklerStringComponentTypeString) && (versionComponentType != SparklerStringComponentTypeString)) {
                return NSOrderedDescending;
            }
        }
    }
    
    if ([currentVersionComponents count] > [versionComponents count]) {
        return NSOrderedDescending;
    } else if ([currentVersionComponents count] < [versionComponents count]) {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

#pragma mark -

+ (NSComparisonResult)compareCurrentPreReleaseVersionComponent: (NSString *)currentPreReleaseVersionComponent toPreReleaseVersionComponent: (NSString *)preReleaseVersionComponent {
    NSString *currentVersionNumber, *currentPreReleaseModifier;
    NSString *versionNumber, *preReleaseModifier;
    
    [currentPreReleaseVersionComponent getCapturesWithRegexAndReferences: SparklerPreReleaseVersionComponentRegex, @"${1}", &currentVersionNumber, @"${2}", &currentPreReleaseModifier, nil];
    [preReleaseVersionComponent getCapturesWithRegexAndReferences: SparklerPreReleaseVersionComponentRegex, @"${1}", &versionNumber, @"${2}", &preReleaseModifier, nil];
    
    NSInteger currentVersionNumberValue = [currentVersionNumber intValue];
    NSInteger versionNumberValue = [versionNumber intValue];
    
    if (currentVersionNumberValue > versionNumberValue) {
        return NSOrderedDescending;
    } else if (currentVersionNumberValue < versionNumberValue) {
        return NSOrderedAscending;
    }
    
    if ([currentPreReleaseModifier isEqualToString: SparklerPreReleaseDevelopmentModifier]) {
        return NSOrderedAscending;
    } else if ([preReleaseModifier isEqualToString: SparklerPreReleaseDevelopmentModifier]) {
        return NSOrderedDescending;
    }
    
    NSComparisonResult comparisonResult = [currentPreReleaseModifier compare: preReleaseModifier];
    
    if (comparisonResult != NSOrderedSame) {
        return comparisonResult;
    }
    
    return NSOrderedSame;
}

#pragma mark -

+ (NSComparisonResult)comparePreReleaseVersionComponent: (NSString *)preReleaseVersionComponent toVersionComponent: (NSString *)versionComponent {
    NSString *versionNumber, *preReleaseModifier;
    SparklerStringComponentType versionComponentType = [SparklerGenericVersionComparator typeFromStringComponent: versionComponent];
    
    [preReleaseVersionComponent getCapturesWithRegexAndReferences: SparklerPreReleaseVersionComponentRegex, @"${1}", &versionNumber, @"${2}", &preReleaseModifier, nil];
    
    if (versionComponentType == SparklerStringComponentTypeNumber) {
        NSInteger versionNumberValue = [versionNumber intValue];
        NSInteger versionComponentValue = [versionComponent intValue];
        
        if (versionNumberValue > versionComponentValue) {
            return NSOrderedDescending;
        } else if (versionNumberValue < versionComponentValue) {
            return NSOrderedAscending;
        }
    }
    
    return NSOrderedAscending;
}

@end
