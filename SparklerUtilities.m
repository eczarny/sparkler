#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerUtilities

+ (NSArray *)applicationBlacklist {
    NSBundle *applicationBundle = [SparklerUtilities applicationBundle];
    NSString *path = [applicationBundle pathForResource: SparklerApplicationBlacklistFile ofType: SparklerPropertyListFileExtension];
    NSDictionary *applicationBlacklistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    return [applicationBlacklistDictionary objectForKey: SparklerBlacklistedApplicationsKey];
}

#pragma mark -

+ (BOOL)saveTargetedApplications: (NSArray *)targetedApplications toFile: (NSString *)file {
    NSString *targetedApplicationsPath = [[SparklerUtilities applicationSupportPathForBundle: [SparklerUtilities applicationBundle]] stringByAppendingPathComponent: file];
    
    return [NSKeyedArchiver archiveRootObject: targetedApplications toFile: targetedApplicationsPath];
}

+ (NSArray *)targetedApplicationsFromFile: (NSString *)file {
    NSString *targetedApplicationsPath = [[SparklerUtilities applicationSupportPathForBundle: [SparklerUtilities applicationBundle]] stringByAppendingPathComponent: file];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile: targetedApplicationsPath];
}

#pragma mark -

+ (NSString *)stringFromBundledHTMLResource: (NSString *)resource {
    NSString *resourcePath = [[SparklerUtilities applicationBundle] pathForResource: resource ofType: SparklerHTMLFileExtension];
    
    return [[[NSString alloc] initWithContentsOfFile: resourcePath encoding: NSUTF8StringEncoding error: nil] autorelease];
}

@end
