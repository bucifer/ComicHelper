//
//  JokeDataManager.m
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "JokeDataManager.h"

@implementation JokeDataManager


-(id)init {
    if ( self = [super init] ) {
        self.jokes = [[NSMutableArray alloc]init];
    }
    return self;
}




@end
