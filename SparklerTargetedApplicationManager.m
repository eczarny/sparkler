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
// Created by Eric Czarny on Sunday, December 14, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerTargetedApplicationManager.h"
#import "SparklerApplicationScanner.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerTargetedApplicationManager

static SparklerTargetedApplicationManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myTargetedApplications = nil;
    }
    
    return self;
}

#pragma mark -

+ (SparklerTargetedApplicationManager *)sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[SparklerTargetedApplicationManager alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSArray *)targetedApplications {
    if (!myTargetedApplications) {
        [self synchronizeWithFilesystem];
    }
    
    return myTargetedApplications;
}

- (void)setTargetedApplications: (NSArray *)targetedApplications {
    if (myTargetedApplications != targetedApplications) {
        [myTargetedApplications release];
        
        myTargetedApplications = [targetedApplications retain];
    }
}

#pragma mark -

- (void)rescanFilesystemForApplications {
    SparklerApplicationScanner *sharedApplicationScanner = [SparklerApplicationScanner sharedScanner];
    
    [sharedApplicationScanner setDelegate: self];
    
    NSLog(@"The targeted application manager is rescanning the filesystem...");
    
    [sharedApplicationScanner scan];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerApplicationsWillUpdateNotification object: self];
}

#pragma mark -

- (void)synchronizeWithFilesystem {
    NSArray *targetedApplications = [SparklerUtilities targetedApplicationsFromFile: SparklerTargetedApplicationFile];
    
    if (!myTargetedApplications && targetedApplications) {
        [self setTargetedApplications: targetedApplications];
        
        NSLog(@"The targeted application manager found application metadata saved to disk.");
        
        return;
    } else if (!myTargetedApplications && !targetedApplications) {
        [self rescanFilesystemForApplications];
    } else {
        NSLog(@"The targeted application manager is saving the current application metadata to disk.");
        
        [SparklerUtilities saveTargetedApplications: myTargetedApplications toFile: SparklerTargetedApplicationFile];
    }
}

#pragma mark -

- (void)applicationScannerDidFindApplications: (NSArray *)applications {
    [self setTargetedApplications: applications];
    
    NSLog(@"The application scanner found targetable applications.");
    
    [self synchronizeWithFilesystem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerApplicationsDidUpdateNotification object: self];
}

- (void)applicationScannerFailedFindingApplications {
    NSLog(@"The application scanner failed to find any targetable applications.");
}

#pragma mark -

- (void)dealloc {
    [myTargetedApplications release];
    
    [super dealloc];
}

@end
