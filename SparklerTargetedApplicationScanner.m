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
// SparklerTargetedApplicationScanner.m
// 
// Created by Eric Czarny on Friday, November 28, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerTargetedApplicationScanner.h"
#import "SparklerTargetedApplication.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerTargetedApplicationScanner (SparklerTargetedApplicationScannerPrivate)

- (void)scanForTargetedApplications;

#pragma mark -

- (NSArray *)scanForTargetedApplicationsAtSearchPath: (NSString *)searchPath;

#pragma mark -

- (void)loadIconsForTargetedApplications: (NSArray *)targetedApplications;

#pragma mark -

- (void)scannerDidFindTargetedApplications: (NSArray *)targetedApplications;

- (void)scannerDidNotFindTargetedApplications;

@end

#pragma mark -

@implementation SparklerTargetedApplicationScanner

static SparklerTargetedApplicationScanner *sharedInstance = nil;

+ (SparklerTargetedApplicationScanner *)sharedScanner {
    if (!sharedInstance) {
        sharedInstance = [[SparklerTargetedApplicationScanner alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (id<SparklerTargetedApplicationScannerDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SparklerTargetedApplicationScannerDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (void)scan {
    [NSThread detachNewThreadSelector: @selector(scanForTargetedApplications) toTarget: self withObject: nil];
}

@end

#pragma mark -

@implementation SparklerTargetedApplicationScanner (SparklerTargetedApplicationScannerPrivate)

- (void)scanForTargetedApplications {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSString *applicationsPath = [NSString stringWithString: SparklerApplicationsPath];
    NSArray *targetedApplications;
    
    NSLog(@"Initiating the scan for applications...");
    
    targetedApplications = [self scanForTargetedApplicationsAtSearchPath: applicationsPath];
    
    NSLog(@"The scan has completed. Sparkler found %d Sparkle-enabled application(s).", [targetedApplications count]);
    
    [self loadIconsForTargetedApplications: targetedApplications];
    
    [self scannerDidFindTargetedApplications: targetedApplications];
    
    [autoreleasePool release];
}

#pragma mark -

- (NSArray *)scanForTargetedApplicationsAtSearchPath: (NSString *)searchPath {
    NSArray *applicationsDirectory = [[NSFileManager defaultManager] directoryContentsAtPath: searchPath];
    NSEnumerator *applicationsDirectoryEnumerator = [applicationsDirectory objectEnumerator];
    NSMutableArray *targetedApplications = [NSMutableArray array];
    NSArray *applicationBlacklist = [SparklerUtilities applicationBlacklist];
    NSString *path;
    
    while (path = [applicationsDirectoryEnumerator nextObject]) {
        path = [searchPath stringByAppendingPathComponent: path];
        
        if ([[path pathExtension] isEqualToString: SparklerApplicationFileExtension]) {
            NSString *applicationName = [[path stringByDeletingPathExtension] lastPathComponent];
            NSString *applicationPath = [NSString stringWithString: path];
            NSBundle *applicationBundle = [NSBundle bundleWithPath: applicationPath];
            
            if ([applicationBlacklist containsObject: applicationName]) {
                NSLog(@"The application scanner found a blacklisted application: %@", applicationName);
                
                continue;
            }
            
            path = [path stringByAppendingPathComponent: SparklerApplicationContentsDirectory];
            path = [path stringByAppendingPathComponent: SparklerApplicationInfoFile];
            
            NSDictionary *applicationInformation = [[NSDictionary alloc] initWithContentsOfFile: path];
            NSString *applicationAppcastURL = [applicationBundle objectForInfoDictionaryKey: SparklerApplicationFeedURL];
            
            if (applicationAppcastURL) {
                SparklerTargetedApplication *targetedApplication = [[SparklerTargetedApplication alloc] initWithName: applicationName path: applicationPath];
                
                [targetedApplication setAppcastURL: [NSURL URLWithString: applicationAppcastURL]];
                
                [targetedApplications addObject: targetedApplication];
                
                [targetedApplication release];
            }
            
            [applicationInformation release];
        } else {
            [targetedApplications addObjectsFromArray: [self scanForTargetedApplicationsAtSearchPath: path]];
        }
    }
    
    return targetedApplications;
}

#pragma mark -

- (void)loadIconsForTargetedApplications: (NSArray *)targetedApplications {
    NSEnumerator *targetedApplicationsEnumerator = [targetedApplications objectEnumerator];
    id targetedApplication;
    
    while (targetedApplication = [targetedApplicationsEnumerator nextObject]) {
        NSImage *targetedApplicationIcon = [[NSWorkspace sharedWorkspace] iconForFile: [targetedApplication path]];
        
        if (targetedApplicationIcon) {
            [targetedApplication setIcon: targetedApplicationIcon];
        }
    }
}

#pragma mark -

- (void)scannerDidFindTargetedApplications: (NSArray *)targetedApplications {
    [myDelegate applicationScannerDidFindTargetedApplications: targetedApplications];
}

- (void)scannerDidNotFindTargetedApplications {
    [myDelegate applicationScannerDidNotFindTargetedApplications];
}

@end
