//
//  JokeDataManager.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Joke.h"
#import "JokeCD.h"
#import "HomeViewController.h"
#import "SetCD.h"
#import "Set.h"

@class HomeViewController;


@interface JokeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokes;
@property (nonatomic, strong) NSMutableArray *sets;

@property (nonatomic, strong) HomeViewController *hvc;
@property (nonatomic, strong) NSNumber* uniqueIDmaxValue;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


//Core Data related
- (void) appInitializationLogic;
- (void) refreshJokesCDDataWithNewFetch;
- (void) refreshSetsCDDataWithNewFetch;

- (void) saveEditedJokeInCoreData: (Joke *) joke;
- (void) saveChangesInContextCoreData;

//For JokeCDs
- (NSMutableArray *) convertCoreDataJokesArrayIntoPresentationLayer: (NSArray *) fetchedObjectsArrayOfCDJokes;
- (Joke *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke;

- (void) createNewJokeInCoreData: (Joke *) newJoke;
- (void) deleteJoke: (NSIndexPath *) indexPath;

- (JokeCD *) getCorrespondingJokeCDFromJokePL: (Joke *) jokePL;


//For SetCDs
- (NSMutableArray *) convertCoreDataSetsIntoPresentationLayer: (NSArray *) fetchedCDSetsArray;
- (void) createNewSetInCoreData: (Set *) newSet;
- (void) deleteSet: (NSIndexPath *) indexPath;
- (SetCD *) getCorrespondingSetCDFromSetPL: (Set *) setPL;



//Logic Related
- (void) sortJokesArrayWithTwoDescriptors: (NSString *) firstDescriptorString secondDescriptor: (NSString *) secondDescriptorString;
- (void) sortArrayWithOneDescriptorString: (NSMutableArray *) myArray descriptor: (NSString *) descriptorString ascending: (BOOL) ascending;
- (BOOL) isScoreInputValid: (int) score;


@end
