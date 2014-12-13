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




- (void) fetchAllParseJokesAsynchronously {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu jokes from Parse server", (unsigned long)objects.count);
            
            BOOL someNewDataNeedsToBeSavedToCache = NO;
            for (JokeParse *jokeParse in objects) {
                if ([self parseJokeAlreadyExistsInCoreDataByJokeName:jokeParse]) {
                    NSLog(@"A Core Data object with name: %@ was synced for objectId", jokeParse.name);
                }
                else if ([self thisJokeIsNewParseJokeDataNotFoundInCoreData:jokeParse.objectId]) {
                    [self convertParseJokeToCoreData:jokeParse];
                    someNewDataNeedsToBeSavedToCache = YES;
                }
            }
            
            if (someNewDataNeedsToBeSavedToCache) {
                [self saveChangesInContextCoreData];
            }
            
            [self.delegate parseDataManagerDidFinishFetchingAllParseJokes];
            
            self.jokesParse = [objects mutableCopy];
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (BOOL) thisJokeIsNewParseJokeDataNotFoundInCoreData: (NSString *) parseObjectID {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectID = %@", parseObjectID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest
                                                                 error:&error];
    if (count == NSNotFound) {
        NSLog(@"Error: %@", error);
    }
    else if (count >= 1) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL) parseJokeAlreadyExistsInCoreDataByJokeName: (JokeParse *) jokeParse {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ AND parseObjectID = nil", jokeParse.name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest
                                                                 error:&error];
    if (count == NSNotFound) {
        NSLog(@"Error: %@", error);
    }
    else if (count >= 1) {
        //we found a joke in Core Data that has the same name as the one on Parse but WITHOUT any objectId
        NSLog(@"we are going to sync a CD Joke without objectId with Parse");
        NSArray *myCoreDataObjectArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        JokeCD *myCoreDataObject = myCoreDataObjectArray[0];
        myCoreDataObject.parseObjectID = jokeParse.objectId;
        [self saveChangesInContextCoreData];
        
        NSLog(@"Core Data Joke: %@, should now have an objectId with %@", myCoreDataObject.name, myCoreDataObject.parseObjectID);
        [self.delegate parseDataManagerDidFinishSyncingCoreDataWithParse];
        
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


- (void) createNewJokeInParse: (JokeCD *) newJoke {
    JokeParse *newJokeParse = [JokeParse object];
    newJokeParse.name = newJoke.name;
    newJokeParse.score = newJoke.score;
    newJokeParse.length = newJoke.length;
    newJokeParse.writeDate = newJoke.writeDate;
    newJokeParse.bodyText = newJoke.bodyText;

    [newJokeParse saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"Joke name: %@  was sent to Parse - finally got saved", newJoke.name);
    }];
}


- (void) createNewSetInParse: (SetCD *) newSet jokesArray: (NSMutableArray *) jokesArray{
    SetParse *newSetParse = [SetParse object];
    newSetParse.name = newSet.name;
    newSetParse.createDate = newSet.createDate;
    
    //I thought we could make this parse array an array of objectIDs
    //but how about the case where it just got created offline, so it doesn't have an objectID?
    //so it'd be better if we create this array out of Names instead. They are unique and it doesn't need an initial communication with Parse, like objectId does.
    
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    for (int i=0; i < jokesArray.count; i++) {
        JokeCD *jokeCD = jokesArray[i];
        NSString *jokeName = jokeCD.name;
        [namesArray addObject: jokeName];
    }
    
    newSetParse.jokes = [namesArray copy];
    
    [newSetParse saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"Set name: %@  was sent to Parse - finally got saved", newSet.name);
    }];
}





- (void) editJokeInParse:(JokeCD *)joke matchString:(NSString *)matchNameString{
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query whereKey:@"name" equalTo:matchNameString];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        JokeParse *myParseJoke = (JokeParse *) object;
        myParseJoke.name = joke.name;
        myParseJoke.length = joke.length;
        myParseJoke.score = joke.score;
        myParseJoke.writeDate = joke.writeDate;
        myParseJoke.bodyText = joke.bodyText;
        [myParseJoke saveEventually:^(BOOL succeeded, NSError *error) {
            NSLog(@"Parse Joke with name %@ should have gotten updated on Parse by now", myParseJoke.name);
        }];
    }];

}

- (void) reorderJokesInSetForParse:(SetCD *)reorderedSet newOrderedArrayOfJokes:(NSMutableArray *)newOrderedArrayOfJokes {
    
    
    
}





//might not need below since Parse's saveEventually and deleteEventually take care of this

//- (void) pushAnyUnsynchedCoreDataJokesToParse {
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity: entity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectID = nil"];
//    [fetchRequest setPredicate:predicate];
//    NSError *error = nil;
//    
//    NSArray *fetchedArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSLog(fetchedArray.description);
//}



@end
