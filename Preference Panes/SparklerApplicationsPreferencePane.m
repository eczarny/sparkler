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
// SparklerApplicationsPreferencePane.h
// 
// Created by Eric Czarny on Saturday, December 13, 2008.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerApplicationsPreferencePane.h"
#import "SparklerApplicationsDataSource.h"
#import "SparklerTargetedApplicationManager.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationsPreferencePane

- (id)init {
    if (self = [super init]) {
        myApplicationsDataSource = [[SparklerApplicationsDataSource alloc] initWithTableView: myApplicationsTableView];
    }
    
    return self;
}

#pragma mark -

- (void)preferencePaneDidLoad {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(applicationsWillUpdate:)
                               name: SparklerApplicationsWillUpdateNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(applicationsDidUpdate:)
                               name: SparklerApplicationsDidUpdateNotification
                             object: nil];
    
    [[SparklerTargetedApplicationManager sharedManager] synchronizeTargetedApplicationsWithFilesystem];
    
    [myApplicationsTableView setDataSource: myApplicationsDataSource];
}

#pragma mark -

- (NSString *)name {
    return ZeroKitLocalizedString(@"Applications");
}

#pragma mark -

- (NSImage *)icon {
    return [SparklerUtilities imageFromResource: @"Application Preferences" inBundle: [SparklerUtilities applicationBundle]];
}

#pragma mark -

- (NSString *)toolTip {
    return nil;
}

#pragma mark -

- (NSView *)view {
    return myView;
}

#pragma mark -

- (void)refreshListOfApplications: (id)sender {
    SparklerTargetedApplicationManager *sharedTargetedApplicationManager = [SparklerTargetedApplicationManager sharedManager];
    
    [sharedTargetedApplicationManager rescanFilesystemForTargetedApplications];
}

#pragma mark -

- (void)viewHelpForPreferencePane: (id)sender {
    NSLog(@"viewHelpForPreferencePane:");
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [myApplicationsDataSource release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark Application Scanner Notifications

#pragma mark -

- (void)applicationsWillUpdate: (NSNotification *)notification {
    [myScanningForApplicationsIndicator startAnimation: nil];
    
    [myRefreshApplicationsButton setEnabled: NO];
}

- (void)applicationsDidUpdate: (NSNotification *)notification {
    [myApplicationsTableView reloadData];
    
    [myScanningForApplicationsIndicator stopAnimation: nil];
    
    [myRefreshApplicationsButton setEnabled: YES];
}

@end
