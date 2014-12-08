//
//  JokeParse.m
//  ParseStarterProject
//
//  Created by Aditya Narayan on 12/5/14.
//
//

#import "JokeParse.h"
#import <Parse/PFObject+Subclass.h>

@implementation JokeParse

@dynamic name;
@dynamic length;
@dynamic score;
@dynamic bodyText;
@dynamic writeDate;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Joke";
}

@end
