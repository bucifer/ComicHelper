//
//  ParseDataManager.h
//  Jest Notes
//
//  Created by Aditya Narayan on 12/5/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokesParse;
@property (nonatomic, strong) NSMutableArray *setsParse;

- (void) getAllParseJokes;

@end
