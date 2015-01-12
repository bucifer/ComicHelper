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
#import "JokeParse.h"
#import "SetCD.h"
#import "Set.h"
#import "ParseDataManager.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"


@class HomeViewController;

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokes;
@property (nonatomic, strong) NSMutableArray *sets;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



//Core Data related
- (void) appInitializationLogic;
- (void) refreshJokesCDDataWithNewFetch;
- (void) refreshSetsCDDataWithNewFetch;

//Conversion Related
- (NSMutableArray *) convertCoreDataJokesArrayIntoPresentationLayer: (NSArray *) fetchedObjectsArrayOfCDJokes;
- (Joke *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke;
- (NSMutableArray *) convertCoreDataSetsIntoPresentationLayer: (NSArray *) fetchedCDSetsArray;

//Creation Related
- (void) createNewJokeInCoreDataAndParse: (Joke *) newJoke;
- (void) createNewSetInCoreDataAndParse: (Set *) newSet;

//Deletion Related
- (void) deleteJoke: (NSIndexPath *) indexPath;
- (void) deleteSet: (NSIndexPath *) indexPath;

//Reordering Related
- (void) reorderJokesOfMySetInCoreDataAndParse: (Set *) reorderedSet;

//Fetching Related
- (JokeCD *) getCorrespondingJokeCDFromJokePL: (Joke *) jokePL;
- (SetCD *) getCorrespondingSetCDFromSetPL: (Set *) setPL;

//Saving Related
- (void) editJokeInCoreDataAndParse: (Joke *) joke tempOldNameStringForParseMatching: (NSString *) oldMatchString;
- (void) saveChangesInContextCoreData;



//Logic & Validation Related
- (void) sortJokesArrayWithTwoDescriptors: (NSString *) firstDescriptorString secondDescriptor: (NSString *) secondDescriptorString;
- (void) sortArrayWithOneDescriptorString: (NSMutableArray *) myArray descriptor: (NSString *) descriptorString ascending: (BOOL) ascending;
- (BOOL) isScoreInputValid: (int) score;
- (BOOL) foundDuplicateJokeNameInCoreData: (NSString *) jokeName;
- (BOOL) foundDuplicateSetNameInCoreData: (NSString *) setName;

@end
