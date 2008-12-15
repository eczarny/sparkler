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
// SparklerApplicationMetadata.m
// 
// Created by Eric Czarny on Wednesday, December 10, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerApplicationMetadata.h"

@implementation SparklerApplicationMetadata

- (id)initWithName: (NSString *)name path: (NSString *)path {
    if (self = [super init]) {
        myName = [name retain];
        myVersion = nil;
        myPath = [path retain];
        myAppcastURL = nil;
        myIcon = nil;
        
        checkForUpdates = YES;
    }
    
    return self;
}

-(id)initWithCoder: (NSCoder*)coder {
    if (self = [super init]) {
        myName = [[coder decodeObjectForKey: @"name"] retain];
        myVersion = [[coder decodeObjectForKey: @"version"] retain];
        myPath = [[coder decodeObjectForKey: @"path"] retain];
        myAppcastURL = [[coder decodeObjectForKey: @"appcastURL"] retain];
        myIcon = [[coder decodeObjectForKey: @"icon"] retain];
        
        checkForUpdates = [coder decodeBoolForKey: @"checkForUpdates"];
    }
    
    return self;
}

#pragma mark -

-(void)encodeWithCoder: (NSCoder*)coder {
    [coder encodeObject: myName forKey: @"name"];
    [coder encodeObject: myVersion forKey: @"version"];
    [coder encodeObject: myPath forKey: @"path"];
    [coder encodeObject: myAppcastURL forKey: @"appcastURL"];
    [coder encodeObject: myIcon forKey: @"icon"];
    
    [coder encodeBool: checkForUpdates forKey: @"checkForUpdates"];
}

#pragma mark -

- (NSString *)name {
    return myName;
}

- (void)setName: (NSString *)name {
    if (myName != name) {
        [myName release];
        
        myName = [name retain];
    }
}

#pragma mark -

- (NSString *)version {
    return myVersion;
}

- (void)setVersion: (NSString *)version {
    if (myVersion != version) {
        [myVersion release];
        
        myVersion = [version retain];
    }
}

#pragma mark -

- (NSString *)path {
    return myPath;
}

- (void)setPath: (NSString *)path {
    if (myPath != path) {
        [myPath release];
        
        myPath = [path retain];
    }
}

#pragma mark -

- (NSString *)appcastURL {
    return myAppcastURL;
}

- (void)setAppcastURL: (NSString *)appcastURL {
    if (myAppcastURL != appcastURL) {
        [myAppcastURL release];
        
        myAppcastURL = [appcastURL retain];
    }
}

#pragma mark -

- (NSImage *)icon {
    return myIcon;
}

- (void)setIcon: (NSImage *)icon {
    if (myIcon != icon) {
        [myIcon release];
        
        myIcon = [icon retain];
    }
}

#pragma mark -

- (BOOL)checkForUpdates {
    return checkForUpdates;
}

- (void)setCheckForUpdates: (BOOL)flag {
    checkForUpdates = flag;
}

#pragma mark -

- (void)dealloc {
    [myName release];
    [myVersion release];
    [myPath release];
    [myAppcastURL release];
    [myIcon release];
    
    [super dealloc];
}

@end
