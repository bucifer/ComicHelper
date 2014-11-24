//
//  JokeDataManager.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "JokeDataManager.h"
#import "JokeCD.h"
#import "Joke.h"
#import "SetCD.h"
#import "Set.h"

@implementation JokeDataManager


-(id)init {
    if (self = [super init] ) {
        self.jokes = [[NSMutableArray alloc]init];
        self.sets = [[NSMutableArray alloc]init];
    }
    return self;
}




#pragma mark Core Data-related
- (void) appInitializationLogic {
    //Let's do initialization logic
    //If it's the first time you are running the app, we don't do anything
    //If it's not the first time you are running the app, we get everything from Core Data and turn them into presentation layer jokes
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:@"notFirstLaunch"] == false)
    {
        NSLog(@"this is first time you are running the app - Do nothing");
        
        //after first launch, you set this NSDefaults key so that for consequent launches, this block never gets run
        [userDefaults setBool:YES forKey:@"notFirstLaunch"];
        [userDefaults synchronize];
    }
    else {
        //this is NOT the first launch ... Fetch from Core Data
        NSArray *fetchedJokesFromCD = [self fetchAndReturnArrayOfCDObjectWithEntityName:@"JokeCD"];
        self.jokes = [self convertCoreDataJokesArrayIntoJokePLs:fetchedJokesFromCD];
        self.uniqueIDmaxValue = [self returnUniqueIDmaxValue];
        [self.hvc.tableView reloadData];
        
        //taking care of fetching SETS now
        
        NSArray *fetchedSetsFromCD = [self fetchAndReturnArrayOfCDObjectWithEntityName:@"SetCD"];
        self.sets = [fetchedSetsFromCD mutableCopy];
        for (SetCD* setCD in self.sets) {
            [setCD valueForKey:@"jokes"];
        }
    }
}


- (NSArray *) fetchAndReturnArrayOfCDObjectWithEntityName: (NSString *) entityString {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityString inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedStuff = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedStuff == nil) {
        NSLog(@"some horrible error in fetching CD: %@", error);
        return nil;
    }
    
    return fetchedStuff;
}





- (void) refreshJokesCDDataWithNewFetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedJokesFromCD = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedJokesFromCD == nil) {
        NSLog(@"some horrible error in fetching CD: %@", error);
    }
    self.jokes = [self convertCoreDataJokesArrayIntoJokePLs:fetchedJokesFromCD];
    NSLog(@"refreshed jokes cd data with new fetch");
}

- (void) refreshSetsCDDataWithNewFetch {
    NSFetchRequest *setsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *setsEntity = [NSEntityDescription entityForName:@"SetCD" inManagedObjectContext:self.managedObjectContext];
    [setsFetchRequest setEntity:setsEntity];
    NSError *error2 = nil;
    NSArray *fetchedSetsFromCD = [self.managedObjectContext executeFetchRequest:setsFetchRequest error:&error2];
    if (fetchedSetsFromCD == nil) {
        NSLog(@"some horrible error in fetching CD: %@", error2);
    }
    self.sets = [fetchedSetsFromCD mutableCopy];
    
    for (SetCD* setCD in self.sets) {
        NSLog(setCD.jokes.description);
    }
    
    NSLog(@"refreshed sets cd data with new fetch");

}

- (NSMutableArray *) convertCoreDataJokesArrayIntoJokePLs: (NSArray *) fetchedObjectsArrayOfCDJokes {
    
    NSMutableArray *resultArrayOfJokePLs = [[NSMutableArray alloc]init];
    
    for (int i=0; i < fetchedObjectsArrayOfCDJokes.count; i++) {
        JokeCD *oneCDJoke = fetchedObjectsArrayOfCDJokes[i];
        Joke *newPLJoke = [[Joke alloc]init];
        newPLJoke.name = oneCDJoke.name;
        newPLJoke.score = [oneCDJoke.score floatValue];
        newPLJoke.length = [oneCDJoke.length intValue];
        newPLJoke.creationDate = oneCDJoke.creationDate;
        newPLJoke.managedObjectID = [oneCDJoke objectID];
        newPLJoke.uniqueID = oneCDJoke.uniqueID;
        [resultArrayOfJokePLs addObject:newPLJoke];
    }
    
    return resultArrayOfJokePLs;
}


#pragma mark JokeCD Related
- (Joke *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke {
    Joke *newPLJoke = [[Joke alloc]init];
    newPLJoke.name = oneCoreDataJoke.name;
    newPLJoke.score = [oneCoreDataJoke.score floatValue];
    newPLJoke.length = [oneCoreDataJoke.length intValue];
    newPLJoke.creationDate = oneCoreDataJoke.creationDate;
    newPLJoke.managedObjectID = [oneCoreDataJoke objectID];
    newPLJoke.uniqueID = oneCoreDataJoke.uniqueID;

    return newPLJoke;
}




- (void) saveEditedJokeInCoreData: (Joke *) jokePL title:(NSString*)title minLength:(NSString*)minLength secLength:(NSString*)secLength score:(NSString*)score date: (NSDate *) date{
    NSError *error;
    JokeCD *correspondingCDJoke = (JokeCD *) [self.managedObjectContext existingObjectWithID:jokePL.managedObjectID error:&error];
    correspondingCDJoke.name = title;
    correspondingCDJoke.length = [NSNumber numberWithInt:([minLength intValue] * 60 + [secLength intValue])];
    correspondingCDJoke.score = [NSNumber numberWithFloat:[score floatValue]];
    correspondingCDJoke.creationDate = date;
    [self saveChangesInContextCoreData];
}


- (void) saveChangesInContextCoreData {
        NSError *err = nil;
        BOOL successful = [self.managedObjectContext save:&err];
        if(!successful){
            NSLog(@"Error saving: %@", [err localizedDescription]);
        } else {
            NSLog(@"Core Data Saved without errors - reporting from JokeDataManager");
        }
}



- (JokeCD *) getCorrespondingJokeCDFromJokePL: (Joke *) jokePL {
    NSError *error;
    JokeCD *correspondingCDJoke = (JokeCD *) [self.managedObjectContext existingObjectWithID:jokePL.managedObjectID error:&error];
    return correspondingCDJoke;
}


- (void) createNewJokeInCoreData: (NSString *) jokeName jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    joke.name = jokeName;
    joke.length = [NSNumber numberWithInt: ([jokeMinuteLength intValue] * 60 + [jokeSecsLength intValue])];
    joke.score = [NSNumber numberWithFloat:[jokeScore floatValue]];
    joke.creationDate = jokeDate;
    joke.uniqueID = [NSNumber numberWithUnsignedInteger:[self.uniqueIDmaxValue intValue] + 1];
    [self saveChangesInContextCoreData];
    
    [self returnUniqueIDmaxValue];
}

- (Joke *) createNewJokeInPresentationLayer: (NSString *) jokeTitle jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate {
    Joke *joke = [[Joke alloc]init];
    joke.name = jokeTitle;
    joke.score = [jokeScore floatValue];
    joke.length = [jokeMinuteLength intValue] * 60 + [jokeSecsLength intValue];
    joke.creationDate = jokeDate;
    joke.uniqueID = [NSNumber numberWithUnsignedInteger:[self.uniqueIDmaxValue intValue] + 1];
    
    [self.jokes addObject:joke];
    
    return joke;
}



#pragma mark SetCDs-related

- (void) createNewSetInCoreData:(NSString *)setName jokes:(NSMutableArray *)jokes{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetCD" inManagedObjectContext:self.managedObjectContext];
    SetCD *set = [[SetCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    set.name = setName;
    
    NSMutableArray *jokeCDArray = [[NSMutableArray alloc]init];
    
    for (int i; i < jokes.count; i++) {
        Joke *joke = jokeCDArray[i];
        JokeCD *jokeCD = [self getCorrespondingJokeCDFromJokePL:joke];
        [jokeCDArray addObject:jokeCD];
    }
    
    set.jokes = [NSOrderedSet orderedSetWithArray:[jokeCDArray copy]];
    
    [self saveChangesInContextCoreData];
}





#pragma mark Logic-Related
- (NSNumber *) returnUniqueIDmaxValue {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"uniqueID==max(uniqueID)"];

    NSError *error = nil;
    NSArray *arrayOfOneJokeWithHighestUniqueID = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (arrayOfOneJokeWithHighestUniqueID == nil) {
        NSLog(@"error in fetching CD: %@", error);
    }
    
    NSNumber *maxValue = nil;
    if (arrayOfOneJokeWithHighestUniqueID)
        if ([arrayOfOneJokeWithHighestUniqueID valueForKeyPath:@"@max.uniqueID.unsignedIntegerValue"] != nil)
            maxValue = [arrayOfOneJokeWithHighestUniqueID valueForKeyPath:@"@max.uniqueID.unsignedIntegerValue"];
        else
            maxValue = [NSNumber numberWithUnsignedInteger:0];
    else
        maxValue = [NSNumber numberWithUnsignedInteger:0];
    
    self.uniqueIDmaxValue = maxValue;
    NSLog(@"Max ID value is %@ for your jokes: From JDM",self.uniqueIDmaxValue);

    return maxValue;
}


- (void) sortJokesArrayWithTwoDescriptors:(NSString *)firstDescriptorString secondDescriptor:(NSString *)secondDescriptorString {
    NSSortDescriptor *scoreSorter = [[NSSortDescriptor alloc]initWithKey:firstDescriptorString ascending:NO];
    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc]initWithKey:secondDescriptorString ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:scoreSorter, dateSorter, nil];
    self.jokes = [[self.jokes sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (void) sortArrayWithOneDescriptorString: (NSMutableArray *) myArray descriptor: (NSString *) descriptorString ascending: (BOOL) ascending{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:descriptorString ascending:ascending];
    myArray = [[NSArray arrayWithObjects:sorter, nil]mutableCopy];
}



- (BOOL) isScoreInputValid: (float) score {
    if (score > 10.0 || score < 0) {
        return FALSE;
    }
    return TRUE;
}



@end
