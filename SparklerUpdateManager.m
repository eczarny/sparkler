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
// SparklerUpdateManager.m
// 
// Created by Eric Czarny on Saturday, April 25, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerUpdateManager.h"
#import "SparklerUpdateEngine.h"

@implementation SparklerUpdateManager

static SparklerUpdateManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myUpdateEngine = [SparklerUpdateEngine sharedEngine];
        
        [myUpdateEngine setDelegate: self];
    }
    
    return self;
}

#pragma mark -

+ (SparklerUpdateManager *)sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[SparklerUpdateManager alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (void)checkForUpdates {
    [myUpdateEngine checkForUpdates];
}

#pragma mark Update Engine Delegate Methods

#pragma mark -

- (void)updateEngineWillCheckForUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler is checking for updates.");
}

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFindUpdatesForTargetedApplications: (NSArray *)targetedApplications {
    NSLog(@"Sparkler found updates for %d application(s).", [targetedApplications count]);
}

- (void)updateEngineDidNotFindUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler did not find any updates.");
}

#pragma mark -

- (void)updateEngineWillDownloadUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler will download the selected updates.");
}

- (void)updateEngineDidFinishDownloadingUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler finished downloading the selected updates.");
}

#pragma mark -

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFailWithError: (NSError *)error {
    NSLog(@"Sparkler failed checking for updates with error: %@", [error localizedDescription]);
}

@end
