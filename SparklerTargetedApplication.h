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
// SparklerTargetedApplication.h
// 
// Created by Eric Czarny on Wednesday, December 10, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import <Cocoa/Cocoa.h>

@interface SparklerTargetedApplication : NSObject<NSCoding> {
    NSString *myName;
    NSString *myVersion;
    NSString *myPath;
    NSString *myAppcastURL;
    NSImage *myIcon;
    BOOL isTargetedForUpdates;
}

- (id)initWithName: (NSString *)name path: (NSString *)path;

- (id)initWithCoder: (NSCoder*)coder;

#pragma mark -

-(void)encodeWithCoder: (NSCoder*)coder;

#pragma mark -

- (NSString *)name;

- (void)setName: (NSString *)name;

#pragma mark -

- (NSString *)version;

- (void)setVersion: (NSString *)version;

#pragma mark -

- (NSString *)path;

- (void)setPath: (NSString *)path;

#pragma mark -

- (NSString *)appcastURL;

- (void)setAppcastURL: (NSString *)appcastURL;

#pragma mark -

- (NSImage *)icon;

- (void)setIcon: (NSImage *)icon;

#pragma mark -

- (BOOL)isTargetedForUpdates;

- (void)setTargetedForUpdates: (BOOL)flag;

@end
