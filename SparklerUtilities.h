#import <Cocoa/Cocoa.h>

@interface SparklerUtilities : ZeroKitUtilities {
    
}

+ (NSArray *)applicationBlacklist;

#pragma mark -

+ (BOOL)saveTargetedApplications: (NSArray *)targetedApplications toFile: (NSString *)file;

+ (NSArray *)targetedApplicationsFromFile: (NSString *)file;

#pragma mark -

+ (NSString *)stringFromBundledHTMLResource: (NSString *)resource;

@end
