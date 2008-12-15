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
// SparklerApplicationsDataSource.m
// 
// Created by Eric Czarny on Saturday, November 29, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import "SparklerApplicationsDataSource.h"
#import "SparklerTargetedApplicationManager.h"
#import "SparklerTargetedApplication.h"
#import "SparklerConstants.h"

@implementation SparklerApplicationsDataSource

- (id)init {
    if (self = [super init]) {
        myApplicationMetadataManager = [SparklerTargetedApplicationManager sharedManager];
        myTableView = nil;
    }
    
    return self;
}

#pragma mark -

- (NSTableView *)tableView {
    return myTableView;
}

- (void)setTableView: (NSTableView *)tableView {
    if (myTableView != tableView) {
        [myTableView release];
        
        myTableView = [tableView retain];
    }
}

#pragma mark -

- (NSInteger)numberOfRowsInTableView: (NSTableView *)tableView {
    NSArray *applications = [myApplicationMetadataManager applications];
    
    return [applications count];
}

- (id)tableView: (NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex {
    NSString *columnIdentifier = (NSString *)[tableColumn identifier];
    NSArray *applications = [myApplicationMetadataManager applications];
    SparklerTargetedApplication *application = [applications objectAtIndex: rowIndex];
    id objectValue;
    
    if ([applications count] == 0) {
        return nil;
    }
    
    if ([columnIdentifier isEqualToString: SparklerApplicationSelectionField]) {
        if ([application targetedForUpdates]) {
            objectValue = [NSNumber numberWithInt: NSOnState];
        } else {
            objectValue = [NSNumber numberWithInt: NSOffState];
        }
    } else if ([columnIdentifier isEqualToString: SparklerApplicationIconField]) {
        objectValue = [application icon];
    } else if ([columnIdentifier isEqualToString: SparklerApplicationNameField]) {
        objectValue = [application name];
    } else if ([columnIdentifier isEqualToString: SparklerApplicationVersionField]) {
        objectValue = [application version];
        
        if (!objectValue) {
            objectValue = @"N/A";
        }
    } else {
        objectValue = nil;
    }
    
    return objectValue;
}

- (void)tableView: (NSTableView *)tableView setObjectValue: (id)objectValue forTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex {
    NSString *columnIdentifier = (NSString *)[tableColumn identifier];
    NSArray *applications = [myApplicationMetadataManager applications];
    SparklerTargetedApplication *application = [applications objectAtIndex: rowIndex];
    
    if ([columnIdentifier isEqualToString: SparklerApplicationSelectionField]) {
        [application setTargetedForUpdates: [objectValue boolValue]];
    }
}

#pragma mark -

- (void)dealloc {
    [myTableView release];
    
    [super dealloc];
}

@end
