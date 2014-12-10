//
//  SetParse.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/10/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SetParse.h"


@implementation SetParse

@dynamic name;
@dynamic createDate;
@dynamic jokes;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Set";
}

@end
