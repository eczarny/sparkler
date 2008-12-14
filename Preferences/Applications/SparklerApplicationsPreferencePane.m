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
#import "SparklerApplicationScanner.h"
#import "SparklerUtilities.h"

@interface SparklerApplicationsPreferencePane (SparklerApplicationsPreferencePanePrivate)

- (void)prepareListOfApplicationsTableView;

@end

#pragma mark -

@implementation SparklerApplicationsPreferencePane

- (id)init {
    if (self = [super init]) {
        myListOfApplicationsDataSource = [[SparklerApplicationsDataSource alloc] init];
    }
    
    return self;
}

#pragma mark -

- (void)preferencePaneDidLoad {
    
}

- (void)preferencePaneDidDisplay {
    [myListOfApplicationsDataSource setTableView: myListOfApplicationsTableView];
    
    [myListOfApplicationsProgressIndicator setDisplayedWhenStopped: NO];
    
    [self prepareListOfApplicationsTableView];
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
    SparklerApplicationScanner *sharedScanner = [SparklerApplicationScanner sharedScanner];
    
    [sharedScanner setDelegate: self];
    
    [myListOfApplicationsProgressIndicator startAnimation: nil];
    
    [myRefreshListOfApplicationsButton setEnabled: NO];
    
    [sharedScanner scan];
}

#pragma mark -

- (IBAction)viewHelpForPreferencePane: (id)sender {
    NSLog(@"refreshListOfApplications:");
}

#pragma mark -

- (void)applicationScannerDidFindApplicationMetadata: (NSArray *)applicationMetadata {
    [myListOfApplicationsDataSource setApplicationMetadata: applicationMetadata];
    
    [myListOfApplicationsProgressIndicator stopAnimation: nil];
    
    [myRefreshListOfApplicationsButton setEnabled: YES];
}

- (void)applicationScannerFailedFindingApplicationMetadata {
    [myListOfApplicationsProgressIndicator stopAnimation: nil];
    
    [myRefreshListOfApplicationsButton setEnabled: YES];
}

#pragma mark -

- (void)dealloc {
    [myListOfApplicationsDataSource release];
    
    [super dealloc];
}

@end
#pragma mark -

@implementation SparklerApplicationsPreferencePane (SparklerApplicationsPreferencePanePrivate)

- (void)prepareListOfApplicationsTableView {
    [myListOfApplicationsTableView setDataSource: myListOfApplicationsDataSource];
    
    [myListOfApplicationsTableView setRowHeight: 40.0];
}

@end

