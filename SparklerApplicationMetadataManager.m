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
// SparklerApplicationMetadataManager.m
// 
// Created by Eric Czarny on Sunday, December 14, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerApplicationMetadataManager.h"
#import "SparklerApplicationScanner.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationMetadataManager

static SparklerApplicationMetadataManager *sharedInstance = nil;

+ (SparklerApplicationMetadataManager *)sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[SparklerApplicationMetadataManager alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        myApplicationMetadata = nil;
    }
    
    return self;
}

#pragma mark -

- (NSArray *)applicationMetadata {
    if (!myApplicationMetadata) {
        [self synchronizeApplicationMetadata];
    }
    
    return myApplicationMetadata;
}

- (void)setApplicationMetadata: (NSArray *)applicationMetadata {
    if (myApplicationMetadata != applicationMetadata) {
        [myApplicationMetadata release];
        
        myApplicationMetadata = [applicationMetadata retain];
    }
}

#pragma mark -

- (void)rescanFilesystemForApplicationMetadata {
    SparklerApplicationScanner *sharedApplicationScanner = [SparklerApplicationScanner sharedScanner];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [sharedApplicationScanner setDelegate: self];
    
    NSLog(@"The application metadata manager is rescanning the filesystem...");
    
    [sharedApplicationScanner scan];
    
    [notificationCenter postNotificationName: SparklerApplicationMetadataWillUpdateNotification object: self];
}

#pragma mark -

- (void)synchronizeApplicationMetadata {
    NSArray *applicationMetadata = [SparklerUtilities sparklerApplicationMetadataFromFile: SparklerApplicationMetadataFile];
    
    if (!myApplicationMetadata && applicationMetadata) {
        [self setApplicationMetadata: applicationMetadata];
        
        NSLog(@"The application metadata manager found application metadata from disk.");
        
        return;
    } else if (!myApplicationMetadata && !applicationMetadata) {
        [self rescanFilesystemForApplicationMetadata];
    } else {
        NSLog(@"The application metadata manager is saving the current application metadata to disk.");
        
        [SparklerUtilities saveSparklerApplicationMetadata: myApplicationMetadata toFile: SparklerApplicationMetadataFile];
    }
}

#pragma mark -

- (void)applicationScannerDidFindApplicationMetadata: (NSArray *)applicationMetadata {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [self setApplicationMetadata: applicationMetadata];
    
    NSLog(@"The application scanner manager found application metadata.");
    
    [self synchronizeApplicationMetadata];
    
    [notificationCenter postNotificationName: SparklerApplicationMetadataDidUpdateNotification object: self];
}

- (void)applicationScannerFailedFindingApplicationMetadata {
    NSLog(@"The application scanner failed to find any application metadata.");
}

#pragma mark -

- (void)dealloc {
    [myApplicationMetadata release];
    
    [super dealloc];
}

@end
