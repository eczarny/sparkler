#import "SparklerTargetedApplication.h"
#import "SparklerGenericVersionComparator.h"
#import "SparklerConstants.h"

@implementation SparklerTargetedApplication

- (id)initWithName: (NSString *)name path: (NSString *)path {
    if (self = [super init]) {
        myName = [name retain];
        myPath = [path retain];
        myAppcastURL = nil;
        myIcon = nil;
        isTargetedForUpdates = YES;
    }
    
    return self;
}

- (id)initWithCoder: (NSCoder*)coder {
    if (self = [super init]) {
        myName = [[coder decodeObjectForKey: @"name"] retain];
        myPath = [[coder decodeObjectForKey: @"path"] retain];
        myAppcastURL = [[coder decodeObjectForKey: @"appcastURL"] retain];
        myIcon = [[coder decodeObjectForKey: @"icon"] retain];
        isTargetedForUpdates = [coder decodeBoolForKey: @"targetedForUpdates"];
    }
    
    return self;
}

#pragma mark -

- (void)encodeWithCoder: (NSCoder*)coder {
    [coder encodeObject: myName forKey: @"name"];
    [coder encodeObject: myPath forKey: @"path"];
    [coder encodeObject: myAppcastURL forKey: @"appcastURL"];
    [coder encodeObject: myIcon forKey: @"icon"];
    [coder encodeBool: isTargetedForUpdates forKey: @"targetedForUpdates"];
}

#pragma mark -

- (NSString *)name {
    return myName;
}

- (void)setName: (NSString *)name {
    if (myName != name) {
        [myName release];
        
        myName = [name retain];
    }
}

#pragma mark -

- (NSString *)version {
    return [[self applicationBundle] objectForInfoDictionaryKey: SparklerApplicationBundleVersion];
}

- (NSString *)displayVersion {
    NSString *shortVersionString = [[self applicationBundle] objectForInfoDictionaryKey: SparklerApplicationBundleShortVersionString];
    
    if (!shortVersionString) {
        shortVersionString = [self version];
    }
    
    return shortVersionString;
}

#pragma mark -

- (NSString *)path {
    return myPath;
}

- (void)setPath: (NSString *)path {
    if (myPath != path) {
        [myPath release];
        
        myPath = [path retain];
    }
}

#pragma mark -

- (NSURL *)appcastURL {
    return myAppcastURL;
}

- (void)setAppcastURL: (NSURL *)appcastURL {
    if (myAppcastURL != appcastURL) {
        [myAppcastURL release];
        
        myAppcastURL = [appcastURL retain];
    }
}

#pragma mark -

- (NSImage *)icon {
    return myIcon;
}

- (void)setIcon: (NSImage *)icon {
    if (myIcon != icon) {
        [myIcon release];
        
        myIcon = [icon retain];
    }
}

#pragma mark -

- (BOOL)isTargetedForUpdates {
    return isTargetedForUpdates;
}

- (void)setTargetedForUpdates: (BOOL)targetedForUpdates {
    isTargetedForUpdates = targetedForUpdates;
}

#pragma mark -

- (NSBundle *)applicationBundle {
    return [NSBundle bundleWithPath: myPath];
}

#pragma mark -

- (NSComparisonResult)compareToVersion: (NSString *)version {
    return [SparklerGenericVersionComparator compareCurrentVersion: [self version] toVersion: version];
}

#pragma mark -

- (void)dealloc {
    [myName release];
    [myPath release];
    [myAppcastURL release];
    [myIcon release];
    
    [super dealloc];
}

@end
