// 
// Copyright (c) 2008 Eric Czarny <eczarny@gmail.com>
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
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerApplicationScanner.h"
#import "SparklerApplicationMetadata.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerApplicationScanner (SparklerApplicationScannerPrivate)

- (void)scanForApplications: (id)arguments;

#pragma mark -

- (void)loadIconsForApplicationMetadata: (NSArray *)applicationMetadata;

#pragma mark -

- (void)scannerDidFinishAndFoundApplicationMetadata: (NSArray *)applicationMetadata;

- (void)scannerFailedFindingApplicationMetadata;

@end

#pragma mark -

@implementation SparklerApplicationScanner

static SparklerApplicationScanner *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myThread = [[NSThread alloc] initWithTarget: self selector: @selector(scanForApplications:) object: nil];
    }
    
    return self;
}

#pragma mark -

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
    [myThread start];
}

@end

#pragma mark -

@implementation SparklerApplicationScanner (SparklerApplicationScannerPrivate)

- (void)scanForApplications: (id)arguments {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSString *applicationsDirectory = [NSString stringWithString: SparklerApplicationsDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *applicationsDirectoryEnumerator = [fileManager enumeratorAtPath: applicationsDirectory];
    NSString *path;
    NSMutableArray *applicationMetadata = [NSMutableArray array];
    
    while (path = [applicationsDirectoryEnumerator nextObject]) {
        if ([[path pathExtension] isEqualToString: SparklerApplicationExtension]) {
            NSString *applicationName = [path stringByDeletingPathExtension];
            NSString *applicationPath = [applicationsDirectory stringByAppendingPathComponent: path];
            
            path = [path stringByAppendingPathComponent: SparklerApplicationContentsDirectory];
            path = [path stringByAppendingPathComponent: SparklerApplicationInfoFile];
            
            NSDictionary *applicationInformation = [[NSDictionary alloc] initWithContentsOfFile: [applicationsDirectory stringByAppendingPathComponent: path]];
            NSString *applicationAppcastURL = [applicationInformation objectForKey: SparklerApplicationSUFeedURL];
            NSString *applicationVersion = [applicationInformation objectForKey: SparklerApplicationCFBundleShortVersionString];
            
            if (applicationAppcastURL) {
                SparklerApplicationMetadata *currentApplicationMetadata = [[SparklerApplicationMetadata alloc] initWithName: applicationName path: applicationPath];
                
                [currentApplicationMetadata setVersion: applicationVersion];
                [currentApplicationMetadata setAppcastURL: applicationAppcastURL];
                
                [applicationMetadata addObject: currentApplicationMetadata];
                
                [currentApplicationMetadata release];
            }
            
            [applicationInformation release];
        }
    }
    
    [self loadIconsForApplicationMetadata: applicationMetadata];
    
    [self scannerDidFinishAndFoundApplicationMetadata: applicationMetadata];
    
    [autoreleasePool release];
}

#pragma mark -

- (void)loadIconsForApplicationMetadata: (NSArray *)applicationMetadata {
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    NSEnumerator *applicationMetadataEnumerator = [applicationMetadata objectEnumerator];
    id currentApplicationMetadata;
    
    while (currentApplicationMetadata = [applicationMetadataEnumerator nextObject]) {
        NSImage *applicationIcon = [sharedWorkspace iconForFile: [currentApplicationMetadata path]];
        
        if (applicationIcon) {
            [currentApplicationMetadata setIcon: applicationIcon];
        }
    }
}

#pragma mark -

- (void)scannerDidFinishAndFoundApplicationMetadata: (NSArray *)applicationMetadata {
    [myDelegate applicationScannerDidFindApplicationMetadata: applicationMetadata];
}

- (void)scannerFailedFindingApplicationMetadata {
    [myDelegate applicationScannerFailedFindingApplicationMetadata];
}

@end
