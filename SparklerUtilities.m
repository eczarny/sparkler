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
// SparklerUtilities.m
// 
// Created by Eric Czarny on Wednesday, November 26, 2008.
// Copyright (c) 2010 Divisible by Zero.
// 

#import "SparklerUtilities.h"
#import "SparklerConstants.h"

@implementation SparklerUtilities

+ (NSArray *)applicationBlacklist {
    NSBundle *applicationBundle = [SparklerUtilities applicationBundle];
    NSString *path = [applicationBundle pathForResource: SparklerApplicationBlacklistFile ofType: SparklerPropertyListFileExtension];
    NSDictionary *applicationBlacklistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    return [applicationBlacklistDictionary objectForKey: SparklerBlacklistedApplicationsKey];
}

#pragma mark -

+ (BOOL)saveTargetedApplications: (NSArray *)targetedApplications toFile: (NSString *)file {
    NSString *targetedApplicationsPath = [[SparklerUtilities applicationSupportPath] stringByAppendingPathComponent: file];
    
    return [NSKeyedArchiver archiveRootObject: targetedApplications toFile: targetedApplicationsPath];
}

+ (NSArray *)targetedApplicationsFromFile: (NSString *)file {
    NSString *targetedApplicationsPath = [[SparklerUtilities applicationSupportPath] stringByAppendingPathComponent: file];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile: targetedApplicationsPath];
}

#pragma mark -

+ (NSString *)stringFromBundledHTMLResource: (NSString *)resource {
    NSString *resourcePath = [[SparklerUtilities applicationBundle] pathForResource: resource ofType: SparklerHTMLFileExtension];
    
    return [[[NSString alloc] initWithContentsOfFile: resourcePath encoding: NSUTF8StringEncoding error: nil] autorelease];
}

@end
