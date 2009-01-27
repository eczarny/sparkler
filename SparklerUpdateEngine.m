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
// SparklerUpdateEngine.m
// 
// Created by Eric Czarny on Friday, December 19, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerUpdateEngine.h"
#import "SparklerTargetedApplicationManager.h"

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

- (SparklerUpdateMonitor *)updateMonitor {
    return myUpdateMonitor;
}

- (void)setUpdateMonitor: (SparklerUpdateMonitor *)updateMonitor {
    if (myUpdateMonitor != updateMonitor) {
        [myUpdateMonitor release];
        
        myUpdateMonitor = [updateMonitor retain];
    }
}

#pragma mark -

- (void)checkForUpdates {
    
}

@end
