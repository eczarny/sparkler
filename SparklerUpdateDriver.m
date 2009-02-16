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
// SparklerUpdateDriver.m
// 
// Created by Eric Czarny on Sunday, December 21, 2008.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerUpdateDriver.h"
#import "SparklerTargetedApplication.h"
#import "SparklerGenericVersionComparator.h"
#import "SparklerUtilities.h"

@interface SparklerUpdateDriver (SparklerUpdateDriverPrivate)

- (BOOL)hostSupportsAppcastItem: (SUAppcastItem *)appcastItem;

#pragma mark -

- (BOOL)isAppcastItemNewer: (SUAppcastItem *)appcastItem;

- (BOOL)appcastItemContainsSkippedVersion: (SUAppcastItem *)appcastItem;

- (BOOL)appcastItemContainsValidUpdate: (SUAppcastItem *)appcastItem;

#pragma mark -

- (void)didFindUpdate;

- (void)didNotFindUpdate;

#pragma mark -

- (void)downloadUpdate;

- (void)extractUpdate;

- (void)installUpdate;

#pragma mark -

- (void)abortUpdateWithError: (NSError *)error;

@end

#pragma mark -

@implementation SparklerUpdateDriver

- (void)checkTargetedApplicationForUpdates: (SparklerTargetedApplication *)targetedApplication {
    SUHost *host = [[[SUHost alloc] initWithBundle: [targetedApplication applicationBundle]] autorelease];
    NSURL *appcastURL = [targetedApplication appcastURL];
    NSString *applicationName = [targetedApplication name];
    NSString *applicationVersion = [targetedApplication version];
    
    if (!appcastURL) {
        NSLog(@"The host, %@/%@, does not contain a valid appcast URL, aborting update check.", applicationName, applicationVersion);
        
        return;
    }
    
    if ([host isRunningOnReadOnlyVolume]) {
        NSLog(@"The host, %@/%@, is running on a read-only volume, aborting update check.", applicationName, applicationVersion);
        
        return;
    }
    
    SUAppcast *appcast = [[SUAppcast alloc] init];
    NSString *userAgent = [NSString stringWithFormat: @"%@/%@ Sparkler/%@", applicationName, applicationVersion, [SparklerUtilities sparklerVersion]];
    
    [appcast setDelegate: self];
    [appcast setUserAgentString: userAgent];
    
    // TODO: Remember to release the targeted application once the update driver is finished.
    myTargetedApplication = [targetedApplication retain];
    
    [appcast fetchAppcastFromURL: appcastURL];
}

#pragma mark -

- (void)abortUpdate {
    
}

#pragma mark -

- (void)appcastDidFinishLoading: (SUAppcast *)appcast {
    NSEnumerator *appcastItemEnumerator = [[appcast items] objectEnumerator];
    SUAppcastItem *appcastItem = nil;
    
    [appcast release];
    
    do {
        appcastItem = [appcastItemEnumerator nextObject];
    } while (appcastItem && ![self hostSupportsAppcastItem: appcastItem]);
    
    if (appcastItem) {
        myAppcastItem = [appcastItem retain];
    } else {
        [self didNotFindUpdate];
        
        return;
    }
    
    if ([self isAppcastItemNewer: myAppcastItem]) {
        [self didFindUpdate];
    } else {
        [self didNotFindUpdate];
    }
}

- (void)appcast: (SUAppcast *)appcast failedToLoadWithError: (NSError *)error {
    NSLog(@"The appcast for %@ failed to load.", [myTargetedApplication name]);
    
    [self abortUpdateWithError: error];
    
    [appcast release];
}

@end

#pragma mark -

@implementation SparklerUpdateDriver (SparklerUpdateDriverPrivate)

- (BOOL)hostSupportsAppcastItem: (SUAppcastItem *)appcastItem {
    NSString *minimumSupportedSystemVersion = [appcastItem minimumSystemVersion];
    NSString *systemVersion = [SUHost systemVersionString];
    
    if (!minimumSupportedSystemVersion || [minimumSupportedSystemVersion isEqualToString: @""]) {
        return YES;
    }
    
    if ([SparklerGenericVersionComparator compareCurrentVersion: minimumSupportedSystemVersion toVersion: systemVersion] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (BOOL)isAppcastItemNewer: (SUAppcastItem *)appcastItem {
    if ([myTargetedApplication compareToVersion: [appcastItem versionString]] == NSOrderedAscending) {
        return YES;
    }
    
    return NO;
}

- (BOOL)appcastItemContainsSkippedVersion: (SUAppcastItem *)appcastItem {
    NSString *skippedVersion = nil;
    
    if (!skippedVersion) {
        return NO;
    }
    
    // TODO: This methods needs to be implemented.
    
    return NO;
}

- (BOOL)appcastItemContainsValidUpdate: (SUAppcastItem *)appcastItem {
    if ([self hostSupportsAppcastItem: appcastItem] && [self isAppcastItemNewer: appcastItem] && ![self appcastItemContainsSkippedVersion: appcastItem]) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (void)didFindUpdate {
    NSLog(@"Sparkler found a new update for %@.", [myTargetedApplication name]);
}

- (void)didNotFindUpdate {
    NSLog(@"Sparkler did not find a new update for %@.", [myTargetedApplication name]);
}

#pragma mark -

- (void)downloadUpdate {
    NSLog(@"The update driver is downloading the update.");
}

- (void)extractUpdate {
    NSLog(@"The update driver is extracting the update.");
}

- (void)installUpdate {
    NSLog(@"The update driver is installing the update.");
}

#pragma mark -

- (void)abortUpdateWithError: (NSError *)error {
    NSLog(@"Aborting the update with the following error: %@", error);
    
    [self abortUpdate];
}

@end
