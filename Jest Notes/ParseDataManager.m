//
//  ParseDataManager.m
//  Jest Notes
//
//  Created by Terry Bu on 12/5/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "ParseDataManager.h"


@implementation ParseDataManager {
    BOOL someNewDataNeedsToBeSavedToCache;
}



#pragma mark custom init

- (id) initWithBoolean {
    self = [super init];
    if (self) {
        someNewDataNeedsToBeSavedToCache = NO;
    }
    return self;
}


#pragma mark Singleton

+ (ParseDataManager*)sharedParseDataManager
{
    //thread-safe way of creating a singleton
    
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



#pragma mark Fetch Related

- (void) fetchAllParseJokesAsynchronously {
    
    PFQuery *userPointerQuery = [PFQuery queryWithClassName:@"Joke"];
    [userPointerQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    PFQuery *userObjectIDStringQuery = [PFQuery queryWithClassName:@"Joke"];
    [userObjectIDStringQuery whereKey:@"user_id" equalTo:[PFUser currentUser].objectId];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[userPointerQuery,userObjectIDStringQuery]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu jokes from Parse server", (unsigned long)objects.count);
            
            [self updateCoreDataWithParseData:objects];
            [self.delegate parseDataManagerDidFinishFetchingAllParseJokes];
    
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) fetchAllParseSets {
    PFQuery *query = [PFQuery queryWithClassName:@"Setrecord"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu Sets from Parse server", (unsigned long)objects.count);
            
            [self updateCoreDataWithNewSets:objects];
            [self.delegate parseDataManagerDidFinishFetchingAllParseSets];

        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void) updateCoreDataWithParseData: (NSArray*) objects{
    
    for (JokeParse *jokeParse in objects) {
        if ([self parseJokeAlreadyExistsInCoreDataByJokeName:jokeParse]) {
            //syncing from Parse so jokes created on device can prevent future Parse jokes from coming in
            NSLog(@"A Core Data object with name: %@ was synced for objectId", jokeParse.name);
        }
        else if ([self thisParseJokeIsNewData:jokeParse.objectId]) {
            //Insertion syncing Parse if something was created off web
            [self convertParseJokeToCoreData:jokeParse];
            someNewDataNeedsToBeSavedToCache = YES;
        }
        else if (![self thisParseJokeIsNewData:jokeParse.objectId] && [self thisParseJokeUpdateTimeMoreRecentThanCoreDataJoke: jokeParse]) {
            //Update syncing
            //1) I create a joke on the web
            //2) I've downloaded it off the web and converted it to Core Data for local caching
            //3) Now, if you ever edit the joke on the web, iOS won't sync the changes because you only check for two things
            //  A) does the joke with the same NAME exist? ---> if yes, then sync it for object-id, don't add as whole new joke
            //  B) does any core data joke have the same objectid? --> if yes, do nothing
            // now we need a whole new system for updating jokes that have been updated on the web
            //using update time .. we now check for C) if this joke is not new from Parse, is its update time more recent?
        }
    }
    
    if (someNewDataNeedsToBeSavedToCache) {
        [self saveChangesInContextCoreData];
    }
    
    //Deletion syncing
    //check if Parse has less jokes than on Device.
    //that's because the web application deleted stuff, but it didn't get reflected properly on device.
    //in that case, get all your core data jokes.
    //find the ones not found in this objects array.
    //delete them from core data
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entity];
    NSError *error = nil;
    NSUInteger coreDataJokesCount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (coreDataJokesCount == NSNotFound) {
        NSLog(@"Error: %@", error);
    }
    else if (coreDataJokesCount >= 1) {
        //check if it's GREATER THAN number of parse jokes
        if (coreDataJokesCount > objects.count) {
            //then something is wrong. Delete out those extra jokes on device
            
        }
    }
    
}
                   
- (BOOL) thisParseJokeUpdateTimeMoreRecentThanCoreDataJoke: (JokeParse *) jokeParse {
    
    JokeCD *jokeCD = [self getCorrespondingJokeCDFromParseObjectID:jokeParse.objectId];
    
    if ([jokeParse.updatedAt compare:jokeCD.updateTime] == NSOrderedDescending) {
        //if we found this, then we have to refresh the core data joke object
        jokeCD.name = jokeParse.name;
        jokeCD.length = jokeParse.length;
        jokeCD.score = jokeParse.score;
        jokeCD.writeDate = jokeParse.writeDate;
        jokeCD.bodyText = jokeParse.bodyText;
        jokeCD.updateTime = jokeParse.updatedAt;
        someNewDataNeedsToBeSavedToCache = YES;
        return YES;
    }
    return NO;
}

                   


- (void) updateCoreDataWithNewSets: (NSArray *) objects {
    for (SetParse *setParse in objects) {
        if ([self thisParseSetIsNewData:setParse.name]) {
            [self convertParseSetToCoreData:setParse];
            someNewDataNeedsToBeSavedToCache = YES;
        }
    }
    
    if (someNewDataNeedsToBeSavedToCache) {
        [self saveChangesInContextCoreData];
    }

}


#pragma mark Checking Logic for Duplicates of Parse objects vs Core Data

- (BOOL) thisParseJokeIsNewData: (NSString *) parseObjectID {
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




- (BOOL) thisParseSetIsNewData: (NSString *) setParseName {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetCD" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", setParseName];
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
        [self.delegate parseDataManagerDidFinishSynchingCoreDataWithParse];
        
        return YES;
    }
    
    return NO;
}



#pragma mark Conversion Related

- (void) convertParseJokeToCoreData: (JokeParse *) jokeParse {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    joke.name = jokeParse.name;
    joke.length = jokeParse.length;
    joke.score = jokeParse.score;
    joke.writeDate = jokeParse.writeDate;
    joke.bodyText = jokeParse.bodyText;
    joke.parseObjectID = jokeParse.objectId;
    joke.username = [PFUser currentUser].username;
    joke.updateTime = jokeParse.updatedAt;
}

- (void) convertParseSetToCoreData: (SetParse *) setParse {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetCD" inManagedObjectContext:self.managedObjectContext];
    SetCD *setCD = [[SetCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    setCD.name = setParse.name;
    setCD.createDate = setParse.createDate;
    setCD.username = [PFUser currentUser].username;
    
    if (setParse.jokes.count > 0) {
        //we have to make a fetch request to all the jokeCDs, and make a nsorderedset by following the ordering of the setParse.jokes
        //when we create a new set, we find the corresponding cd joke from jokepl and add it to the nsorderedset attribute
        NSMutableArray *jokeCDArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < setParse.jokes.count; i++) {
            NSString *jokeNameString = setParse.jokes[i];
            JokeCD *jokeCD = [self getCorrespondingJokeCDFromJokeNameString: jokeNameString];
            [jokeCDArray addObject:jokeCD];
        }
        setCD.jokes = [NSOrderedSet orderedSetWithArray:[jokeCDArray copy]];
    }
}

- (JokeCD*) getCorrespondingJokeCDFromJokeNameString: (NSString *) jokeNameString {
   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
   NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
   // Specify criteria for filtering which objects to fetch
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", jokeNameString];
    [fetchRequest setPredicate:predicate];

   NSError *error = nil;
   NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
   if (fetchedObjects == nil) {
       NSLog(@"Error: %@", error);
   }
    
   return fetchedObjects[0];
}

- (JokeCD*) getCorrespondingJokeCDFromParseObjectID: (NSString *) parseObjectID {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectID == %@", parseObjectID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error: %@", error);
    }
    
    return fetchedObjects[0];
}


#pragma mark Creation Related

- (void) createNewJokeInParse: (JokeCD *) newJoke {
    JokeParse *newJokeParse = [JokeParse object];
    newJokeParse.name = newJoke.name;
    newJokeParse.score = newJoke.score;
    newJokeParse.length = newJoke.length;
    newJokeParse.writeDate = newJoke.writeDate;
    newJokeParse.bodyText = newJoke.bodyText;
    
    PFUser *user = [PFUser currentUser];
    newJokeParse[@"user"] = user;
    newJokeParse.user_id = user.objectId;
    
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
    
    newSetParse[@"user"] = [PFUser currentUser];
    
    [newSetParse saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"Set name: %@  was sent to Parse - finally got saved", newSet.name);
    }];
}



#pragma mark Editing and Reordering related 

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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Setrecord"];
    [query whereKey:@"name" equalTo:reorderedSet.name];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        SetParse *myParseSet = (SetParse *) object;
        
        NSMutableArray *namesArray = [[NSMutableArray alloc]init];
        for (int i=0; i < newOrderedArrayOfJokes.count; i++) {
            JokeCD *jokeCD = newOrderedArrayOfJokes[i];
            NSString *jokeName = jokeCD.name;
            [namesArray addObject: jokeName];
        }
        myParseSet.jokes = [namesArray copy];
        
        [myParseSet saveEventually:^(BOOL succeeded, NSError *error) {
            NSLog(@"newly ordered Parse set got saved on Parse eventually");
        }];
    }];

    
}


#pragma mark Deletion Related

- (void) deleteJokeFromParseBasedOnId: (NSString *) objectId {
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"From deletion: Couldn't find corresponding PFObject based on objectId");
        }
        else {
            [object deleteEventually];
        }
    }];
}

- (void) deleteJokeFromParseBasedOnName: (NSString *) jokeName {
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query whereKey:@"name" equalTo:jokeName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"Deleting joke %@ by name from Parse", jokeName);
        PFObject *object = objects[0];
        [object deleteEventually];
    }];
}

- (void) deleteSet:(SetCD *)setCD {
    PFQuery *query = [PFQuery queryWithClassName:@"Setrecord"];
    [query whereKey:@"name" equalTo:setCD.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *object = objects[0];
        [object deleteEventually];
    }];
}



#pragma mark MISCELLANEOUS

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
