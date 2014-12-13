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

@protocol JokeDataManagerDelegate;


@interface JokeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokes;
@property (nonatomic, strong) NSMutableArray *sets;
@property (nonatomic, strong) HomeViewController *hvc;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) id <JokeDataManagerDelegate> delegate;



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

//Fetching Related
- (JokeCD *) getCorrespondingJokeCDFromJokePL: (Joke *) jokePL;
- (SetCD *) getCorrespondingSetCDFromSetPL: (Set *) setPL;

//Saving Related
- (void) saveEditedJokeInCoreData: (Joke *) joke;
- (void) saveChangesInContextCoreData;


//Logic & Validation Related
- (void) sortJokesArrayWithTwoDescriptors: (NSString *) firstDescriptorString secondDescriptor: (NSString *) secondDescriptorString;
- (void) sortArrayWithOneDescriptorString: (NSMutableArray *) myArray descriptor: (NSString *) descriptorString ascending: (BOOL) ascending;
- (BOOL) isScoreInputValid: (int) score;
- (BOOL) foundDuplicateJokeNameInCoreData: (NSString *) jokeName;

@end



//in case you want to implement this later for some functionality

@protocol JokeDataManagerDelegate


@end
