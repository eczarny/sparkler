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
    NSString *applicationsDirectory = [NSString stringWithString: SparklerApplicationsDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *sparklerApplicationPath = [applicationsDirectory stringByAppendingPathComponent: SparklerApplicationName];
    
    if ([fileManager fileExistsAtPath: sparklerApplicationPath]) {
        NSBundle *applicationBundle = [NSBundle bundleWithPath: sparklerApplicationPath];
        NSString *bundleIdentifier = [applicationBundle bundleIdentifier];
        
        if (applicationBundle && ([bundleIdentifier isEqualToString: SparklerBundleIdentifier])) {
            NSLog(@"Returning bundle with identifier: %@", bundleIdentifier);
            
            return applicationBundle;
        }
    }
    
    return [NSBundle mainBundle];
}

+ (NSBundle *)sparklerHelperBundle {
    NSBundle *sparklerBundle = [SparklerUtilities sparklerBundle];
    NSString *sparklerHelperPath = [sparklerBundle pathForResource: SparklerHelperApplicationName ofType: SparklerApplicationExtension];
    
    NSLog(@"Returning bundle at path: %@", sparklerHelperPath);
    
    return [NSBundle bundleWithPath: sparklerHelperPath];
}

#pragma mark -

+ (NSString *)sparklerVersion {
    NSBundle *sparklerBundle = [SparklerUtilities sparklerBundle];
    NSString *sparlerVersion = [sparklerBundle objectForInfoDictionaryKey: SparklerApplicationCFBundleShortVersionString];
    
    if (!sparlerVersion) {
        sparlerVersion = [sparklerBundle objectForInfoDictionaryKey: SparklerApplicationCFBundleVersion];
    }
    
    return sparlerVersion;
}

#pragma mark -

+ (void)registerDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults: [SparklerUtilities existingSparklerDefaults]];
}

#pragma mark -

+ (NSString *)applicationSupportPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportPath = SparklerApplicationSupportPath;
    
    applicationSupportPath = [applicationSupportPath stringByExpandingTildeInPath];
    
    if (![fileManager fileExistsAtPath: applicationSupportPath]) {
        [fileManager createDirectoryAtPath: applicationSupportPath attributes: nil];
    }
    
    return applicationSupportPath;
}

#pragma mark -

+ (BOOL)saveTargetedApplications: (NSArray *)targetedApplications toFile: (NSString *)file {
    NSString *applicationSupportPath = [SparklerUtilities applicationSupportPath];
    
    return [NSKeyedArchiver archiveRootObject: targetedApplications toFile: [applicationSupportPath stringByAppendingPathComponent: file]];
}

+ (NSArray *)targetedApplicationsFromFile: (NSString *)file {
    NSString *applicationSupportPath = [SparklerUtilities applicationSupportPath];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile: [applicationSupportPath stringByAppendingPathComponent: file]];
}

#pragma mark -

+ (NSImage *)imageFromBundledImageResource: (NSString *)imageResource {
    NSString *path = [[SparklerUtilities sparklerBundle] pathForImageResource: imageResource];
    NSImage *image = [[[NSImage alloc] initWithContentsOfFile: path] autorelease];
    
    return image;
}

#pragma mark -

+ (float)heightOfToolbarForWindow: (NSWindow *)window {
    NSToolbar *toolbar;
    float toolbarHeight = 0.0;
    
    if (window) {
        toolbar = [window toolbar];
        
        if(toolbar && [toolbar isVisible]) {
            NSRect windowFrame = [NSWindow contentRectForFrameRect: [window frame] styleMask: [window styleMask]];
            
            toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
        }
    }
    
    return toolbarHeight;
}

@end

#pragma mark -

@implementation SparklerUtilities (SparklerUtilitiesPrivate)

+ (NSDictionary *)existingSparklerDefaults {
    NSDictionary *existingSparklerDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName: SparklerHelperApplicationBundleIdentifier];
    NSString *path = [[SparklerUtilities sparklerBundle] pathForResource: @"Defaults" ofType: @"plist"];
    
    NSLog(@"Loading defaults from: %@", path);
    
    if (!existingSparklerDefaults) {
        existingSparklerDefaults = [[[NSMutableDictionary alloc] initWithContentsOfFile: path] autorelease];
    }
    
    NSLog(@"Found existing defaults: %@", existingSparklerDefaults);
    
    return existingSparklerDefaults;
}

@end
