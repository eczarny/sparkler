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
// SparklerApplicationUpdateManager.m
// 
// Created by Eric Czarny on Saturday, April 25, 2009.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerApplicationUpdateManager.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerUpdateEngine.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationUpdateManager

static SparklerApplicationUpdateManager *sharedInstance = nil;

- (id)init {
    if (self = [super init]) {
        myUpdateEngine = [SparklerUpdateEngine sharedEngine];
        
        [myUpdateEngine setDelegate: self];
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

+ (SparklerApplicationUpdateManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

#pragma mark -

- (NSArray *)applicationUpdates {
    return [myUpdateEngine applicationUpdates];
}

#pragma mark -

- (void)checkForUpdates {
    [myUpdateEngine checkForUpdates];
}

#pragma mark -

- (void)installUpdates {
    [myUpdateEngine installUpdates];
}

#pragma mark -

#pragma mark Update Engine Delegate Methods

#pragma mark -

- (void)updateEngineWillCheckForApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler is checking for updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerWillCheckForApplicationUpdatesNotification object: self];
}

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFindApplicationUpdates: (NSArray *)applicationUpdates {
    NSLog(@"Sparkler found updates for %d application(s).", [applicationUpdates count]);
    
    [[NSApplication sharedApplication] requestUserAttention: NSInformationalRequest];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerDidFindApplicationUpdatesNotification object: self];
}

- (void)updateEngineDidNotFindApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler did not find any updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerDidNotFindApplicationUpdatesNotification object: self];
}

#pragma mark -

- (void)updateEngineWillDownloadApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler will download the selected updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerWillDownloadApplicationUpdatesNotification object: self];
}

- (void)updateEngineDidFinishDownloadingApplicationUpdates: (SparklerUpdateEngine *)updateEngine {
    NSLog(@"Sparkler finished downloading the selected updates.");
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SparklerDidDownloadApplicationUpdatesNotification object: self];
}

#pragma mark -

- (void)updateEngine: (SparklerUpdateEngine *)updateEngine didFailWithError: (NSError *)error {
    NSLog(@"Sparkler failed checking for updates with error: %@", [error localizedDescription]);
}

@end
