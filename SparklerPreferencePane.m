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
// SparklerPreferencePane.m
// 
// Created by Eric Czarny on Saturday, December 13, 2009.
// Copyright (c) 2009 Divisible by Zero.
// 

#import "SparklerPreferencePane.h"
#import "SparklerConstants.h"

@interface SparklerPreferencePane (SparklerPreferencePanePrivate)

- (NSString *)nibName;

@end

#pragma mark -

@implementation SparklerPreferencePane

- (id)init {
    if (self = [super init]) {
        myView = nil;
    }
    
    return self;
}

#pragma mark -

- (void)preferencePaneDidLoad {
    NSLog(@"The %@ preference pane did load.", [self name]);
}

- (void)preferencePaneDidDisplay {
    NSLog(@"The %@ preference pane did display.", [self name]);
}

- (void)viewDidLoad {
    [self preferencePaneDidDisplay];
}

#pragma mark -

- (NSString *)name {
    return nil;
}

#pragma mark -

- (NSImage *)icon {
    return nil;
}

#pragma mark -

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    if (!myView) {
        NSString *nibName = [self nibName];
        
        if (![NSBundle loadNibNamed: nibName owner: self]) {
            NSLog(@"Failed loading the preference pane's view from the Nib named: %@", nibName);
        } else {
            [self viewDidLoad];
        }
    }
    
    return myView;
}

#pragma mark -

- (void)dealloc {
    [myView release];
    
    [super dealloc];
}

@end

#pragma mark -

@implementation SparklerPreferencePane (SparklerPreferencePanePrivate)

- (NSString *)nibName {
    NSString *preferencePaneName = [self name];
    NSString *nibNamePrefix = SparklerNibName;
    NSString *nibname = [nibNamePrefix stringByAppendingString: preferencePaneName];
    
    return [nibname stringByAppendingString: SparklerPreferencePaneNibNameEnding];
}

@end
