//
//  ParseDataManager.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/5/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "ParseDataManager.h"


@implementation ParseDataManager

- (void) getAllParseJokesAsynchronously {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu jokes from Parse server", objects.count);
            // Do something with the found objects
            
            BOOL someNewDataNeedsToBeSavedToCache = NO;
            
            for (JokeParse *jokeParse in objects) {
                if ([self parseObjectAlreadyExistsInCoreData:jokeParse]) {
                    NSLog(@"the parse object you just queried was already found in CD - NO ACTION");
                }
                else {
                    [self convertParseJokeToCoreData:jokeParse];
                    someNewDataNeedsToBeSavedToCache = YES;
                }
            }
            
            if (someNewDataNeedsToBeSavedToCache)
                [self saveChangesInContextCoreData];
            
            [self.delegate parseDataManagerDidFinishGettingAllParseJokes];
            
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
    if (error != nil)
        NSLog(@"Any error from parseObjectAlreadyExistsinCD method: %@", error);
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] == 0) {
        return NO;
    }
    else {
        return YES;
    }
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


@end
