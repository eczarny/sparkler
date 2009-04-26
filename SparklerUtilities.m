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
// SparklerUtilities.m
// 
// Created by Eric Czarny on Wednesday, November 26, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerUtilities (SparklerUtilitiesPrivate)

+ (NSDictionary *)existingSparklerDefaults;

@end

#pragma mark -

@implementation SparklerUtilities

+ (NSBundle *)sparklerBundle {
    return [NSBundle mainBundle];
}

+ (NSString *)sparklerVersion {
    NSBundle *sparklerBundle = [SparklerUtilities sparklerBundle];
    NSString *sparklerVersion = [sparklerBundle objectForInfoDictionaryKey: SparklerApplicationBundleShortVersionString];
    
    if (!sparklerVersion) {
        sparklerVersion = [sparklerBundle objectForInfoDictionaryKey: SparklerApplicationBundleVersion];
    }
    
    return sparklerVersion;
}

#pragma mark -

+ (void)registerDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults: [SparklerUtilities existingSparklerDefaults]];
}

#pragma mark -

+ (NSString *)applicationSupportPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportPath = ([paths count] > 0) ? [paths objectAtIndex: 0] : NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    applicationSupportPath = [applicationSupportPath stringByAppendingPathComponent: SparklerApplicationName];
    
    if (![fileManager fileExistsAtPath: applicationSupportPath isDirectory: nil]) {
        NSLog(@"The application support directory does not exist, it will be created.");
        
        if (![fileManager createDirectoryAtPath: applicationSupportPath attributes: nil]) {
            NSLog(@"There was a problem creating the application support directory at path: %@", applicationSupportPath);
        }
    }
    
    return applicationSupportPath;
}

#pragma mark -

+ (BOOL)saveTargetedApplications: (NSArray *)targetedApplications toFile: (NSString *)file {
    return [NSKeyedArchiver archiveRootObject: targetedApplications toFile: [[SparklerUtilities applicationSupportPath] stringByAppendingPathComponent: file]];
}

+ (NSArray *)targetedApplicationsFromFile: (NSString *)file {
    return [NSKeyedUnarchiver unarchiveObjectWithFile: [[SparklerUtilities applicationSupportPath] stringByAppendingPathComponent: file]];
}

#pragma mark -

+ (NSImage *)imageFromBundledImageResource: (NSString *)imageResource {
    NSString *path = [[SparklerUtilities sparklerBundle] pathForImageResource: imageResource];
    NSImage *image = [[[NSImage alloc] initWithContentsOfFile: path] autorelease];
    
    return image;
}

@end

#pragma mark -

@implementation SparklerUtilities (SparklerUtilitiesPrivate)

+ (NSDictionary *)existingSparklerDefaults {
    NSDictionary *existingSparklerDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName: SparklerHelperBundleIdentifier];
    NSString *path = [[SparklerUtilities sparklerBundle] pathForResource: @"Defaults" ofType: @"plist"];
    
    if (!existingSparklerDefaults) {
        existingSparklerDefaults = [[[NSMutableDictionary alloc] initWithContentsOfFile: path] autorelease];
    }
    
    NSLog(@"Found existing defaults: %@", existingSparklerDefaults);
    
    return existingSparklerDefaults;
}

@end
