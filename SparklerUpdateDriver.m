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
// SparklerUpdateDriver.m
// 
// Created by Eric Czarny on Sunday, December 21, 2008.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerUpdateDriver.h"
#import "SparklerTargetedApplication.h"
#import "SparklerApplicationUpdate.h"
#import "SparklerGenericVersionComparator.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@interface SparklerUpdateDriver (SparklerUpdateDriverPrivate)

- (BOOL)hostSupportsAppcastItem: (SUAppcastItem *)appcastItem;

#pragma mark -

- (BOOL)isAppcastItemNewer: (SUAppcastItem *)appcastItem;

- (BOOL)appcastItemContainsValidUpdate: (SUAppcastItem *)appcastItem;

#pragma mark -

- (void)didFindUpdate;

- (void)didNotFindUpdate;

#pragma mark -

- (void)downloadUpdate;

#pragma mark -

- (void)extractUpdate;

- (void)installUpdate;

#pragma mark -

- (void)abortUpdateWithError: (NSError *)error;

@end

#pragma mark -

@implementation SparklerUpdateDriver

- (id)initWithDelegate: (id<SparklerUpdateDriverDelegate>)delegate {
    if (self = [super init]) {
        myTargetedApplication = nil;
        myApplicationUpdate = nil;
        myDelegate = delegate;
    }
    
    return self;
}

#pragma mark -

- (SparklerTargetedApplication *)targetedApplication {
    return myTargetedApplication;
}

#pragma mark -

- (SparklerApplicationUpdate *)applicationUpdate {
    return myApplicationUpdate;
}

#pragma mark -

- (id<SparklerUpdateDriverDelegate>)delegate {
    return myDelegate;
}

- (void)setDelegate: (id<SparklerUpdateDriverDelegate>)delegate {
    myDelegate = delegate;
}

#pragma mark -

- (void)checkTargetedApplicationForUpdates: (SparklerTargetedApplication *)targetedApplication {
    SUHost *host = [[[SUHost alloc] initWithBundle: [targetedApplication applicationBundle]] autorelease];
    NSURL *appcastURL = [targetedApplication appcastURL];
    NSString *applicationName = [targetedApplication name];
    NSString *applicationVersion = [targetedApplication version];
    
    if (myTargetedApplication || myApplicationUpdate) {
        NSLog(@"The update driver is currently working, aborting update check.");
        
        return;
    }
    
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
    
    myTargetedApplication = [targetedApplication retain];
    
    [appcast fetchAppcastFromURL: appcastURL];
}

#pragma mark -

- (void)installApplicationUpdate: (SparklerApplicationUpdate *)applicationUpdate {
    
}

#pragma mark -

- (void)abortUpdate {
    NSLog(@"Aborting the %@ update.", [myTargetedApplication name]);
}

#pragma mark -

- (void)dealloc {
    [myTargetedApplication release];
    [myApplicationUpdate release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Appcast Delegate Methods

#pragma mark -

- (void)appcastDidFinishLoading: (SUAppcast *)appcast {
    NSEnumerator *appcastItemEnumerator = [[appcast items] objectEnumerator];
    SUAppcastItem *appcastItem = nil;
    
    [appcast release];
    
    do {
        appcastItem = [appcastItemEnumerator nextObject];
    } while (appcastItem && ![self hostSupportsAppcastItem: appcastItem]);
    
    if (!appcastItem) {
        [self didNotFindUpdate];
        
        return;
    }
    
    if ([self isAppcastItemNewer: appcastItem]) {
        myApplicationUpdate = [[SparklerApplicationUpdate alloc] initWithAppcastItem: appcastItem targetedApplication: myTargetedApplication];
        
        [self didFindUpdate];
    } else {
        [self didNotFindUpdate];
    }
}

- (void)appcast: (SUAppcast *)appcast failedToLoadWithError: (NSError *)error {
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

- (BOOL)appcastItemContainsValidUpdate: (SUAppcastItem *)appcastItem {
    if ([self hostSupportsAppcastItem: appcastItem] && [self isAppcastItemNewer: appcastItem]) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (void)didFindUpdate {
    [myDelegate updateDriver: self didFindApplicationUpdate: myApplicationUpdate];
}

- (void)didNotFindUpdate {
    [myDelegate updateDriverDidNotFindApplicationUpdate: self];
}

#pragma mark -

- (void)downloadUpdate {
    NSURLDownload *download;
    NSURLRequest *request = [NSURLRequest requestWithURL: [[myApplicationUpdate appcastItem] fileURL]];
    
    download = [[NSURLDownload alloc] initWithRequest: request delegate: self];
    
    if (!download) {
        NSLog(@"There was a problem initiating the download!");
    }
}

#pragma mark -

- (void)extractUpdate {
    NSLog(@"The update driver is extracting the update.");
}

- (void)installUpdate {
    NSLog(@"The update driver is installing the update.");
}

#pragma mark -

- (void)abortUpdateWithError: (NSError *)error {
    [self abortUpdate];
    
    [myDelegate updateDriver: self didFailWithError: error];
}

#pragma mark URL Download Delegate Methods

#pragma mark -

- (void)download: (NSURLDownload *)download decideDestinationWithSuggestedFilename: (NSString *)suggestedFilename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *installablePath = [myApplicationUpdate installablePath];
    
    if (!installablePath) {
        NSLog(@"The installable path could not be determined, the download is unable continue.");
        
        [download cancel];
        
        return;
    }
    
    if ([fileManager fileExistsAtPath: installablePath isDirectory: NULL]) {
        [fileManager removeItemAtPath: installablePath error: nil];
    }
    
    [download setDestination: installablePath allowOverwrite: YES];
}

- (void)downloadDidFinish: (NSURLDownload *)download {
    [myDelegate updateDriver: self didFinishDownloadingApplicationUpdate: myApplicationUpdate];
    
    [download release];
}

- (void)download: (NSURLDownload *)download didFailWithError: (NSError *)error {
    [self abortUpdateWithError: error];
    
    [download release];
}

@end
