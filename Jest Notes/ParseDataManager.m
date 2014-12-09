//
//  ParseDataManager.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/5/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "ParseDataManager.h"


@implementation ParseDataManager


#pragma mark Singleton Methods

+ (ParseDataManager*)sharedParseDataManager
{
    // 1
    static ParseDataManager *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ParseDataManager alloc] init];
    });
    return _sharedInstance;
}




- (void) getAllParseJokesAsynchronously {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu jokes from Parse server", objects.count);
            // Do something with the found objects
            
            BOOL someNewDataNeedsToBeSavedToCache = NO;
            
            for (JokeParse *jokeParse in objects) {
                if ([self parseObjectAlreadyExistsInCoreData:jokeParse]) {
//                    NSLog(@"the parse object you just queried was already found in CD - NO ACTION");
                }
                else {
                    [self convertParseJokeToCoreData:jokeParse];
                    someNewDataNeedsToBeSavedToCache = YES;
                }
            }
            
            if (someNewDataNeedsToBeSavedToCache)
                [self saveChangesInContextCoreData];
            
            [self.delegate parseDataManagerDidFinishGettingAllParseJokes];
            
            self.jokesParse = [objects mutableCopy];
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (BOOL) parseObjectAlreadyExistsInCoreData: (JokeParse *) jokeParse {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectID = %@", jokeParse.objectId];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest
                                                                 error:&error];
    if (count == NSNotFound) {
        NSLog(@"Error: %@", error);
    }
    else if (count >= 1) {
        return YES;
    }
    
    return NO;
}

- (void) convertParseJokeToCoreData: (JokeParse *) jokeParse {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    joke.name = jokeParse.name;
    joke.length = jokeParse.length;
    joke.score = jokeParse.score;
    joke.writeDate = jokeParse.writeDate;
    joke.bodyText = jokeParse.bodyText;
    joke.parseObjectID = jokeParse.objectId;
}

- (void) saveChangesInContextCoreData {
    NSError *err = nil;
    BOOL successful = [self.managedObjectContext save:&err];
    if(!successful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    } else {
        NSLog(@"Core Data Saved without errors");
    }
}




- (void) createNewJokeInParse: (Joke *) newJoke {
    JokeParse *newJokeParse = [JokeParse object];
    newJokeParse.name = newJoke.name;
    newJokeParse.score = [NSNumber numberWithInt:newJoke.score];
    newJokeParse.length = [NSNumber numberWithInt:newJoke.length];
    newJokeParse.writeDate = newJoke.writeDate;
    newJokeParse.bodyText = newJoke.bodyText;
    [newJokeParse saveInBackground];
}



@end
