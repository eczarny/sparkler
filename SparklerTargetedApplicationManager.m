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
// SparklerTargetedApplicationManager.m
// 
// Created by Eric Czarny on Sunday, December 14, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerTargetedApplicationManager.h"
#import "SparklerApplicationScanner.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerTargetedApplicationManager

static SparklerTargetedApplicationManager *sharedInstance = nil;

+ (SparklerTargetedApplicationManager *)sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[SparklerTargetedApplicationManager alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        myApplications = nil;
    }
    
    return self;
}

#pragma mark -

- (NSArray *)applications {
    if (!myApplications) {
        [self synchronize];
    }
    
    return myApplications;
}

- (void)setApplications: (NSArray *)applications {
    if (myApplications != applications) {
        [myApplications release];
        
        myApplications = [applications retain];
    }
}

#pragma mark -

- (void)rescanFilesystemForApplications {
    SparklerApplicationScanner *sharedApplicationScanner = [SparklerApplicationScanner sharedScanner];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [sharedApplicationScanner setDelegate: self];
    
    NSLog(@"The application metadata manager is rescanning the filesystem...");
    
    [sharedApplicationScanner scan];
    
    [notificationCenter postNotificationName: SparklerApplicationsWillUpdateNotification object: self];
}

#pragma mark -

- (void)synchronize {
    NSArray *applications = [SparklerUtilities sparklerApplicationMetadataFromFile: SparklerTargetedApplicationFile];
    
    if (!myApplications && applications) {
        [self setApplications: applications];
        
        NSLog(@"The application metadata manager found application metadata from disk.");
        
        return;
    } else if (!myApplications && !applications) {
        [self rescanFilesystemForApplications];
    } else {
        NSLog(@"The targeted application manager is saving the current application metadata to disk.");
        
        [SparklerUtilities saveSparklerApplicationMetadata: myApplications toFile: SparklerTargetedApplicationFile];
    }
}

#pragma mark -

- (void)applicationScannerDidFindApplications: (NSArray *)applications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self setApplications: applications];
    
    NSLog(@"The application scanner manager found applications.");
    
    [self synchronize];
    
    [notificationCenter postNotificationName: SparklerApplicationsDidUpdateNotification object: self];
}

- (void)applicationScannerFailedFindingApplications {
    NSLog(@"The application scanner failed to find any applications.");
}

#pragma mark -

- (void)dealloc {
    [myApplications release];
    
    [super dealloc];
}

@end
