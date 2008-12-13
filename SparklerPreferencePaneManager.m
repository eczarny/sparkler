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
// SparklerPreferencePaneManager.m
// 
// Created by Eric Czarny on Friday, December 12, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerPreferencePaneManager.h"
#import "SparklerPreferencePaneProtocol.h"
#import "SparklerPreferencePane.h"
#import "SparklerUtilities.h"

@implementation SparklerPreferencePaneManager

static SparklerPreferencePaneManager *sharedInstance = nil;

+ (SparklerPreferencePaneManager *)sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[SparklerPreferencePaneManager alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        myPreferencePanes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark -

- (void)loadPreferencePanes {
    NSBundle *sparklerBundle = [SparklerUtilities sparklerBundle];
    NSString *path = [sparklerBundle pathForResource: @"Preferences" ofType: @"plist"];
    NSDictionary *preferencePaneDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSEnumerator *preferencePaneNameEnumerator = [preferencePaneDictionary keyEnumerator];
    NSString *preferencePaneName;
    
    NSLog(@"The preference pane manager is loading preference panes from: %@", path);
    
    while (preferencePaneName = [preferencePaneNameEnumerator nextObject]) {
        NSString *preferencePaneClassName = [preferencePaneDictionary objectForKey: preferencePaneName];
        
        if (preferencePaneClassName) {
            Class preferencePaneClass = [sparklerBundle classNamed: preferencePaneClassName];
            
            if (preferencePaneClass) {
                SparklerPreferencePane *preferencePane = [[preferencePaneClass alloc] init];
                
                if (preferencePane) {
                    [preferencePane preferencePaneDidLoad];
                    
                    [myPreferencePanes setObject: preferencePane forKey: preferencePaneName];
                    
                    [preferencePane release];
                } else {
                    NSLog(@"Failed initializing preference pane named: %@", preferencePaneName);
                }
            } else {
                NSLog(@"Unable to load preference pane with class named: ", preferencePaneClassName);
            }
        } else {
            NSLog(@"The preference pane, %@, is missing a class name!", preferencePaneName);
        }
    }
}

#pragma mark -

- (id<SparklerPreferencePaneProtocol>)preferencePaneWithName: (NSString *)name {
    if (!myPreferencePanes || ([myPreferencePanes count] < 1)) {
        [self loadPreferencePanes];
    }
    
    return [myPreferencePanes objectForKey: name];
}

#pragma mark -

- (NSArray *)preferencePanes {
    if (!myPreferencePanes || ([myPreferencePanes count] < 1)) {
        [self loadPreferencePanes];
    }
    
    return [myPreferencePanes allValues];
}

- (NSArray *)preferencePaneNames {
    if (!myPreferencePanes || ([myPreferencePanes count] < 1)) {
        [self loadPreferencePanes];
    }
    
    return [myPreferencePanes allKeys];
}

#pragma mark -

- (void)dealloc {
    [myPreferencePanes release];
    
    [super dealloc];
}

@end
