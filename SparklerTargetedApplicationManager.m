// 
// Copyright (c) 2010 Eric Czarny <eczarny@gmail.com>
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
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerTargetedApplicationManager.h"
#import "SparklerTargetedApplicationScanner.h"
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

+ (id)allocWithZone: (NSZone *)zone {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [super allocWithZone: zone];
            
            return sharedInstance;
        }
    }
    
    return nil;
}

#pragma mark -

+ (SparklerTargetedApplicationManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSArray *)targetedApplications {
    if (!myTargetedApplications) {
        [self synchronizeTargetedApplicationsWithFilesystem];
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

- (void)rescanFilesystemForTargetedApplications {
    SparklerTargetedApplicationScanner *sharedApplicationScanner = [SparklerTargetedApplicationScanner sharedScanner];
    
    [sharedApplicationScanner setDelegate: self];
    
    NSLog(@"The targeted application manager is rescanning the filesystem.");
    
    [sharedApplicationScanner scan];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerApplicationsWillUpdateNotification object: self];
}

#pragma mark -

- (void)synchronizeTargetedApplicationsWithFilesystem {
    NSArray *targetedApplications = [SparklerUtilities targetedApplicationsFromFile: SparklerTargetedApplicationFile];
    
    if (!myTargetedApplications && targetedApplications) {
        [self setTargetedApplications: targetedApplications];
        
        NSLog(@"The targeted application manager found application metadata saved to disk.");
        
        return;
    } else if (!myTargetedApplications && !targetedApplications) {
        [self rescanFilesystemForTargetedApplications];
    } else {
        NSLog(@"The targeted application manager is saving the current application metadata to disk.");
        
        if (![SparklerUtilities saveTargetedApplications: myTargetedApplications toFile: SparklerTargetedApplicationFile]) {
            NSLog(@"Unable to save the application metadata to disk.");
        }
    }
}

#pragma mark -

- (void)dealloc {
    [myTargetedApplications release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Application Scanner Delegate Methods

#pragma mark -

- (void)applicationScannerDidFindTargetedApplications: (NSArray *)targetedApplications {
    [self setTargetedApplications: targetedApplications];
    
    [self synchronizeTargetedApplicationsWithFilesystem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerApplicationsDidUpdateNotification object: self];
}

- (void)applicationScannerDidNotFindTargetedApplications {
    NSLog(@"The application scanner failed to find any targetable applications.");
}

@end
