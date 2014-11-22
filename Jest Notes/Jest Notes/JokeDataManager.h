//
//  JokeDataManager.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JokePL.h"
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


- (void) saveEditedJokeInCoreData: (JokePL *) jokePL title:(NSString*)title minLength:(NSString*)minLength secLength:(NSString*)secLength score:(NSString*)score date: (NSDate *) date;
- (void) saveChangesInContextCoreData;

//For JokeCDs
- (NSMutableArray *) convertCoreDataJokesArrayIntoJokePLs: (NSArray *) fetchedObjectsArrayOfCDJokes;
- (JokePL *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke;
- (void) createNewJokeInCoreData: (NSString *) jokeName jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate;
- (JokePL *) createNewJokeInPresentationLayer: (NSString *) jokeTitle jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate;

//For SetCDs
- (void) createNewSetInCoreData: (NSString *) setName;

//Logic Related
- (NSNumber *) returnUniqueIDmaxValue;
- (void) sortJokesArrayWithTwoDescriptors: (NSString *) firstDescriptorString secondDescriptor: (NSString *) secondDescriptorString;
- (void) sortArrayWithOneDescriptorString: (NSMutableArray *) myArray descriptor: (NSString *) descriptorString ascending: (BOOL) ascending;
- (BOOL) isScoreInputValid: (float) score;


@end
