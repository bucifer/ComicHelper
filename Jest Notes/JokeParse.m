//
//  JokeParse.m
//  ParseStarterProject
//
//  Created by Terry Bu on 12/5/14.
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
@dynamic user_id;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Joke";
}

@end
