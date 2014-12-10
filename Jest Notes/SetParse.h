//
//  SetParse.h
//  Jest Notes
//
//  Created by Aditya Narayan on 12/10/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Parse/Parse.h>

@interface SetParse : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSDate *createDate;
@property (retain) NSArray *jokes;

+ (NSString *)parseClassName;


@end
