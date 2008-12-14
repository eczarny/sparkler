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
// SparklerApplicationsPreferencePane.h
// 
// Created by Eric Czarny on Saturday, December 13, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerApplicationsPreferencePane.h"
#import "SparklerApplicationsDataSource.h"
#import "SparklerApplicationMetadataManager.h"
#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationsPreferencePane

- (id)init {
    if (self = [super init]) {
        myListOfApplicationsDataSource = [[SparklerApplicationsDataSource alloc] init];
    }
    
    return self;
}

#pragma mark -

- (void)preferencePaneDidLoad {
    SparklerApplicationMetadataManager *sharedApplicationMetadataManager = [SparklerApplicationMetadataManager sharedManager];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector(applicationMetadataWillUpdate:)
                               name: SparklerApplicationMetadataWillUpdateNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector(applicationMetadataDidUpdate:)
                               name: SparklerApplicationMetadataDidUpdateNotification
                             object: nil];
    
    [sharedApplicationMetadataManager synchronizeApplicationMetadata];
}

- (void)preferencePaneDidDisplay {
    [myListOfApplicationsDataSource setTableView: myListOfApplicationsTableView];
    
    [myListOfApplicationsProgressIndicator setDisplayedWhenStopped: NO];
    
    [myListOfApplicationsTableView setDataSource: myListOfApplicationsDataSource];
}

#pragma mark -

- (NSString *)name {
    return @"Applications";
}

#pragma mark -

- (NSImage *)icon {
    return [SparklerUtilities imageFromBundledImageResource: @"Application Preferences"];
}

#pragma mark -

- (IBAction)refreshListOfApplications: (id)sender {
    SparklerApplicationMetadataManager *sharedApplicationMetadataManager = [SparklerApplicationMetadataManager sharedManager];
    
    [sharedApplicationMetadataManager rescanFilesystemForApplicationMetadata];
}

#pragma mark -

- (IBAction)viewHelpForPreferencePane: (id)sender {
    NSLog(@"refreshListOfApplications:");
}

#pragma mark -

- (void)applicationMetadataWillUpdate: (NSNotification *)notification {
    [myListOfApplicationsProgressIndicator startAnimation: nil];
    
    [myRefreshListOfApplicationsButton setEnabled: NO];
}

- (void)applicationMetadataDidUpdate: (NSNotification *)notification {
    [myListOfApplicationsTableView reloadData];
    
    [myListOfApplicationsProgressIndicator stopAnimation: nil];

    [myRefreshListOfApplicationsButton setEnabled: YES];
}

#pragma mark -

- (void)dealloc {
    [myListOfApplicationsDataSource release];
    
    [super dealloc];
}

@end
