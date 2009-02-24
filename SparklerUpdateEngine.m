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
// SparklerUpdateEngine.m
// 
// Created by Eric Czarny on Friday, December 19, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerUpdateEngine.h"
#import "SparklerTargetedApplicationManager.h"
#import "SparklerTargetedApplication.h"
#import "SparklerUpdateDriver.h"

@implementation SparklerUpdateEngine

static SparklerUpdateEngine *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myTargetedApplicationManager = [SparklerTargetedApplicationManager sharedManager];
    }
    
    return self;
}

#pragma mark -

+ (SparklerUpdateEngine *)sharedEngine {
    if (!sharedInstance) {
        sharedInstance = [[SparklerUpdateEngine alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (id<SparklerUpdateEngineDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SparklerUpdateEngineDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (void)checkForUpdates {
    NSArray *targetedApplications = [myTargetedApplicationManager targetedApplications];
    NSEnumerator *targetedApplicationsEnumerator = [targetedApplications objectEnumerator];
    SparklerTargetedApplication *targetedApplication;
    
    [myDelegate updateEngineWillCheckForUpdates: self];
    
    while (targetedApplication = [targetedApplicationsEnumerator nextObject]) {
        if ([targetedApplication isTargetedForUpdates]) {
            SparklerUpdateDriver *updateDriver = [[SparklerUpdateDriver alloc] initWithDelegate: self];
            
            // This will leak like a sieve until a better workflow has been decided on. We're just testing for now.
            [updateDriver checkTargetedApplicationForUpdates: targetedApplication];
        }
    }
}

#pragma mark -

- (void)downloadUpdatesForTargetedApplications: (NSArray *)targetedApplications {
    
}

#pragma mark -

- (void)updateDriverDidFindUpdate: (SparklerUpdateDriver *)updateDriver {
    NSLog(@"Sparkler found a new update for %@, it will be downloaded now.", [[updateDriver targetedApplication] name]);
}

- (void)updateDriverDidNotFindUpdate: (SparklerUpdateDriver *)updateDriver {
    NSLog(@"Sparkler did not find a new update for %@.", [[updateDriver targetedApplication] name]);
}

#pragma mark -

- (void)updateDriverDidFinishDownloadingUpdate: (SparklerUpdateDriver *)updateDriver {
    NSLog(@"The update for %@ has been downloaded.", [[updateDriver targetedApplication] name]);
}

#pragma mark -

- (void)updateDriver: (SparklerUpdateDriver *)updateDriver didFailWithError: (NSError *)error {
    NSLog(@"The update for %@ failed with error: %@", [[updateDriver targetedApplication] name], [error localizedDescription]);
}

@end
