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
// SparklerApplicationsDataSource.h
// 
// Created by Eric Czarny on Saturday, November 29, 2008.
// Copyright (c) 2008 Divisible by Zero.
// 

#import <Cocoa/Cocoa.h>

@interface SparklerApplicationsDataSource : NSObject {
    NSTableView *myTableView;
}

- (id)initWithTableView: (NSTableView *)tableView;

#pragma mark -

- (NSTableView *)tableView;

- (void)setTableView: (NSTableView *)tableView;

#pragma mark -

- (NSInteger)numberOfRowsInTableView: (NSTableView *)tableView;

- (id)tableView: (NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex;

- (void)tableView: (NSTableView *)tableView setObjectValue: (id)object  forTableColumn: (NSTableColumn *)tableColumn row: (NSInteger)rowIndex;

@end