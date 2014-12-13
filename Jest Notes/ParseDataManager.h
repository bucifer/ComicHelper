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
#import "JokeCD.h"
#import "SetCD.h"
#import "JokeParse.h"
#import "SetParse.h"


@protocol ParseDataManagerDelegate;

@interface ParseDataManager : NSObject


+ (ParseDataManager*) sharedParseDataManager;



@property (nonatomic, strong) NSMutableArray *jokesParse;
@property (nonatomic, strong) NSMutableArray *setsParse;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <ParseDataManagerDelegate> delegate;



- (void) fetchAllParseJokesAsynchronously;

- (void) createNewJokeInParse: (JokeCD *) newJoke;
- (void) createNewSetInParse: (SetCD*) newSet;


@end


@protocol ParseDataManagerDelegate

- (void) parseDataManagerDidFinishFetchingAllParseJokes;

- (void) parseDataManagerDidFinishSyncingCoreDataWithParse;

@end