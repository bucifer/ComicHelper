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

- (void) saveEditedJokeInCoreData: (Joke *) jokePL title:(NSString*)title minLength:(NSString*)minLength secLength:(NSString*)secLength score:(NSString*)score date: (NSDate *) date bodyText: (NSString *) bodyText;
- (void) saveChangesInContextCoreData;

//For JokeCDs
- (NSMutableArray *) convertCoreDataJokesArrayIntoPresentationLayer: (NSArray *) fetchedObjectsArrayOfCDJokes;
- (Joke *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke;
- (void) createNewJokeInCoreData: (NSString *) jokeName jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate bodyText: (NSString*) bodyText;
- (Joke *) createNewJokeInPresentationLayer: (NSString *) jokeTitle jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate bodyText: (NSString*) bodyText;

//For SetCDs
- (void) createNewSetInCoreData: (NSString *) setName jokes: (NSMutableArray *) jokes;

//Logic Related
- (NSNumber *) returnUniqueIDmaxValue;
- (void) sortJokesArrayWithTwoDescriptors: (NSString *) firstDescriptorString secondDescriptor: (NSString *) secondDescriptorString;
- (void) sortArrayWithOneDescriptorString: (NSMutableArray *) myArray descriptor: (NSString *) descriptorString ascending: (BOOL) ascending;
- (BOOL) isScoreInputValid: (float) score;


@end
