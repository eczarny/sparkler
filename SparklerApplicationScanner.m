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
// SparklerApplicationScanner.m
// 
// Created by Eric Czarny on Friday, November 28, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerApplicationScanner.h"
#import "SparklerTargetedApplication.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerApplicationScanner (SparklerApplicationScannerPrivate)

- (void)scanForApplications;

#pragma mark -

- (NSArray *)scanForApplicationsAtSearchPath: (NSString *)searchPath;

#pragma mark -

- (void)loadIconsForApplications: (NSArray *)applications;

#pragma mark -

- (void)scannerDidFinishAndFoundApplications: (NSArray *)applications;

- (void)scannerFailedFindingApplications;

@end

#pragma mark -

@implementation SparklerApplicationScanner

static SparklerApplicationScanner *sharedInstance = nil;

+ (SparklerApplicationScanner *)sharedScanner {
    if (!sharedInstance) {
        sharedInstance = [[SparklerApplicationScanner alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (id<SparklerApplicationScannerDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SparklerApplicationScannerDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (void)scan {
    [NSThread detachNewThreadSelector: @selector(scanForApplications) toTarget: self withObject: nil];
}

@end

#pragma mark -

@implementation SparklerApplicationScanner (SparklerApplicationScannerPrivate)

- (void)scanForApplications {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSString *applicationsPath = [NSString stringWithString: SparklerApplicationsPath];
    NSArray *applications;
    
    NSLog(@"Initiating the scan for applications...");
    
    applications = [self scanForApplicationsAtSearchPath: applicationsPath];
    
    NSLog(@"The scan has completed. Sparkler found %d Sparkle-enabled application(s).", [applications count]);
    
    [self loadIconsForApplications: applications];
    
    [self scannerDidFinishAndFoundApplications: applications];
    
    [autoreleasePool release];
}

#pragma mark -

- (NSArray *)scanForApplicationsAtSearchPath: (NSString *)searchPath {
    NSArray *applicationsDirectory = [[NSFileManager defaultManager] directoryContentsAtPath: searchPath];
    NSEnumerator *applicationsDirectoryEnumerator = [applicationsDirectory objectEnumerator];
    NSMutableArray *applications = [NSMutableArray array];
    NSString *path;
    
    while (path = [applicationsDirectoryEnumerator nextObject]) {
        path = [searchPath stringByAppendingPathComponent: path];
        
        if ([[path pathExtension] isEqualToString: SparklerApplicationExtension]) {
            NSString *applicationName = [[path stringByDeletingPathExtension] lastPathComponent];
            NSString *applicationPath = [NSString stringWithString: path];
            NSBundle *applicationBundle = [NSBundle bundleWithPath: applicationPath];
            
            path = [path stringByAppendingPathComponent: SparklerApplicationContentsDirectory];
            path = [path stringByAppendingPathComponent: SparklerApplicationInfoFile];
            
            NSDictionary *applicationInformation = [[NSDictionary alloc] initWithContentsOfFile: path];
            NSString *applicationAppcastURL = [applicationBundle objectForInfoDictionaryKey: SparklerApplicationFeedURL];
            
            if (applicationAppcastURL) {
                SparklerTargetedApplication *application = [[SparklerTargetedApplication alloc] initWithName: applicationName path: applicationPath];
                
                [application setAppcastURL: [NSURL URLWithString: applicationAppcastURL]];
                
                [applications addObject: application];
                
                [application release];
            }
            
            [applicationInformation release];
        } else {
            [applications addObjectsFromArray: [self scanForApplicationsAtSearchPath: path]];
        }
    }
    
    return applications;
}

#pragma mark -

- (void)loadIconsForApplications: (NSArray *)applications {
    NSEnumerator *applicationsEnumerator = [applications objectEnumerator];
    id application;
    
    while (application = [applicationsEnumerator nextObject]) {
        NSImage *applicationIcon = [[NSWorkspace sharedWorkspace] iconForFile: [application path]];
        
        if (applicationIcon) {
            [application setIcon: applicationIcon];
        }
    }
}

#pragma mark -

- (void)scannerDidFinishAndFoundApplications: (NSArray *)applications {
    [myDelegate applicationScannerDidFindApplications: applications];
}

- (void)scannerFailedFindingApplications {
    [myDelegate applicationScannerFailedFindingApplications];
}

@end
