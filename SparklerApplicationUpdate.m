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
// SparklerApplicationUpdate.m
// 
// Created by Eric Czarny on Monday, April 27, 2009.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerApplicationUpdate.h"
#import "SparklerTargetedApplication.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationUpdate

- (id)initWithAppcastItem: (SUAppcastItem *)appcastItem targetedApplication: (SparklerTargetedApplication *)targetedApplication {
    if (self = [super init]) {
        myAppcastItem = [appcastItem retain];
        myTargetedApplication = [targetedApplication retain];
        isMarkedForInstallation = NO;
    }
    
    return self;
}

#pragma mark -

- (SUAppcastItem *)appcastItem {
    return myAppcastItem;
}

- (void)setAppcastItem: (SUAppcastItem *)appcastItem {
    if (myAppcastItem != appcastItem) {
        [myAppcastItem release];
        
        myAppcastItem = [appcastItem retain];
    }
}

#pragma mark -

- (SparklerTargetedApplication *)targetedApplication {
    return myTargetedApplication;
}

- (void)setTargetedApplication: (SparklerTargetedApplication *)targetedApplication {
    if (myTargetedApplication != targetedApplication) {
        [myTargetedApplication release];
        
        myTargetedApplication = [targetedApplication retain];
    }
}

#pragma mark -

- (BOOL)isMarkedForInstallation {
    return isMarkedForInstallation;
}

- (void)setMarkedForInstallation: (BOOL)markedForInstallation {
    isMarkedForInstallation = markedForInstallation;
}

#pragma mark -

- (NSString *)installablePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportPath = [SparklerUtilities applicationSupportPath];
    NSString *downloadPath = [applicationSupportPath stringByAppendingPathComponent: SparklerDownloadsDirectory];
    NSString *fileExtension;
    NSString *filename;
    BOOL isDirectory;
    
    if (![fileManager fileExistsAtPath: downloadPath isDirectory: &isDirectory] && isDirectory) {
        if (![fileManager createDirectoryAtPath: downloadPath attributes: nil]) {
            NSLog(@"There was a problem creating the download directory at path: %@", downloadPath);
            
            return nil;
        }
    }
    
    fileExtension = [[[myAppcastItem fileURL] absoluteString] pathExtension];
    filename = [NSString stringWithFormat: @"%@ %@.%@", [myTargetedApplication name], [self targetVersion], fileExtension];
    
    return [downloadPath stringByAppendingPathComponent: filename];
}

#pragma mark -

- (NSString *)targetVersion {
    return [myAppcastItem displayVersionString];
}

#pragma mark -

- (void)dealloc {
    [myAppcastItem release];
    [myTargetedApplication release];
    
    [super dealloc];
}

@end
