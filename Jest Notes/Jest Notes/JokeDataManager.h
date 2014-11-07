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

@class HomeViewController;


@interface JokeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokes;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) HomeViewController *hvc;

- (void) appInitializationLogic;
- (NSMutableArray *) convertCoreDataJokesArrayIntoJokePLs: (NSArray *) fetchedObjectsArrayOfCDJokes;
- (JokePL *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke;
- (void) saveEditedJokeInCoreData: (JokePL *) jokePL title:(NSString*)title minLength:(NSString*)minLength secLength:(NSString*)secLength score:(NSString*)score date: (NSDate *) date;
- (void) saveChangesInCoreData;




@end
