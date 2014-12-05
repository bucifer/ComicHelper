//
//  ParseDataManager.h
//  Jest Notes
//
//  Created by Aditya Narayan on 12/5/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "JokeParse.h"
#import "JokeCD.h"


@protocol ParseDataManagerDelegate;

@interface ParseDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokesParse;
@property (nonatomic, strong) NSMutableArray *setsParse;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <ParseDataManagerDelegate> delegate;


- (void) getAllParseJokesAsynchronously;




@end


@protocol ParseDataManagerDelegate

- (void) parseDataManagerDidFinishGettingAllParseJokes;

@end