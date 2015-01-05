//
//  ParseDataManager.h
//  Jest Notes
//
//  Created by Terry Bu on 12/5/14.
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


//Fetch Related
- (void) fetchAllParseJokesAsynchronously;
- (void) fetchAllParseSets;

//Create Related
- (void) createNewJokeInParse: (JokeCD *) newJoke;
- (void) createNewSetInParse: (SetCD *) newSet jokesArray: (NSMutableArray *) jokesArray;

//Edit & Reorder Related

- (void) editJokeInParse: (JokeCD *) joke matchString:(NSString *)matchNameString;
- (void) reorderJokesInSetForParse: (SetCD*) reorderedSet newOrderedArrayOfJokes:(NSMutableArray *) newOrderedArrayOfJokes;

//Deletion Related
- (void) deleteJokeFromParseBasedOnId: (NSString *) objectId;
- (void) deleteJokeFromParseBasedOnName: (NSString *) jokeName;
- (void) deleteSet: (SetCD *) setCD;

@end






@protocol ParseDataManagerDelegate

- (void) parseDataManagerDidFinishFetchingAllParseJokes;
- (void) parseDataManagerDidFinishSynchingCoreDataWithParse;
- (void) parseDataManagerDidFinishFetchingAllParseSets;

@end