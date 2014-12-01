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




#pragma mark Initialization Logic
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
        //this is NOT the first launch ... Fetch Jokesfrom Core Data
        NSArray *fetchedJokesFromCD = [self fetchAndReturnArrayOfCDObjectWithEntityName:@"JokeCD"];
        self.jokes = [self convertCoreDataJokesArrayIntoPresentationLayer:fetchedJokesFromCD];
        self.uniqueIDmaxValue = [self returnUniqueIDmaxValue];
        [self.hvc.tableView reloadData];
        
        //taking care of fetching SETS now
        NSArray *fetchedSetsFromCD = [self fetchAndReturnArrayOfCDObjectWithEntityName:@"SetCD"];
        self.sets = [self convertCoreDataSetsIntoPresentationLayer:fetchedSetsFromCD];
    
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



#pragma mark Refresh-Logic Core Data-Related

- (void) refreshJokesCDDataWithNewFetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedJokesFromCD = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedJokesFromCD == nil) {
        NSLog(@"some horrible error in fetching CD: %@", error);
    }
    self.jokes = [self convertCoreDataJokesArrayIntoPresentationLayer:fetchedJokesFromCD];
//    NSLog(@"refreshed jokes cd data with new fetch");
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
//    NSLog(@"refreshed sets cd data with new fetch");

}

#pragma mark Converting Core Data/Presentation Layer logic

- (NSMutableArray *) convertCoreDataJokesArrayIntoPresentationLayer: (NSArray *) fetchedObjectsArrayOfCDJokes {
    
    NSMutableArray *resultArrayOfJokePLs = [[NSMutableArray alloc]init];
    
    for (int i=0; i < fetchedObjectsArrayOfCDJokes.count; i++) {
        JokeCD *oneCDJoke = fetchedObjectsArrayOfCDJokes[i];
        Joke *newPLJoke = [[Joke alloc]init];
        newPLJoke.name = oneCDJoke.name;
        newPLJoke.score = [oneCDJoke.score floatValue];
        newPLJoke.length = [oneCDJoke.length intValue];
        newPLJoke.writeDate = oneCDJoke.writeDate;
        newPLJoke.managedObjectID = [oneCDJoke objectID];
        newPLJoke.uniqueID = oneCDJoke.uniqueID;
        newPLJoke.bodyText = oneCDJoke.bodyText;
        [resultArrayOfJokePLs addObject:newPLJoke];
    }
    
    return resultArrayOfJokePLs;
}

- (Joke *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke {
    Joke *newPLJoke = [[Joke alloc]init];
    newPLJoke.name = oneCoreDataJoke.name;
    newPLJoke.score = [oneCoreDataJoke.score floatValue];
    newPLJoke.length = [oneCoreDataJoke.length intValue];
    newPLJoke.writeDate = oneCoreDataJoke.writeDate;
    newPLJoke.managedObjectID = [oneCoreDataJoke objectID];
    newPLJoke.uniqueID = oneCoreDataJoke.uniqueID;
    newPLJoke.bodyText = oneCoreDataJoke.bodyText;
    
    return newPLJoke;
}


#pragma mark Joke Object-related


- (void) saveEditedJokeInCoreData: (Joke *) joke {
    NSError *error;
    JokeCD *correspondingCDJoke = (JokeCD *) [self.managedObjectContext existingObjectWithID:joke.managedObjectID error:&error];
    correspondingCDJoke.name = joke.name;
    correspondingCDJoke.length = [NSNumber numberWithInt:joke.length];
    correspondingCDJoke.score = [NSNumber numberWithFloat:joke.score];
    correspondingCDJoke.writeDate = joke.writeDate;
    correspondingCDJoke.bodyText = joke.bodyText;
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


- (void) createNewJokeInCoreData: (NSString *) jokeName jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate bodyText: (NSString*) bodyText{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    joke.name = jokeName;
    joke.length = [NSNumber numberWithInt: ([jokeMinuteLength intValue] * 60 + [jokeSecsLength intValue])];
    joke.score = [NSNumber numberWithFloat:[jokeScore floatValue]];
    joke.writeDate = jokeDate;
    joke.uniqueID = [NSNumber numberWithUnsignedInteger:[self.uniqueIDmaxValue intValue] + 1];
    joke.bodyText = bodyText;
    
    [self saveChangesInContextCoreData];
    [self returnUniqueIDmaxValue];
}

- (Joke *) createNewJokeInPresentationLayer: (NSString *) jokeTitle jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate bodyText:(NSString *)bodyText{
    Joke *joke = [[Joke alloc]init];
    joke.name = jokeTitle;
    joke.score = [jokeScore floatValue];
    joke.length = [jokeMinuteLength intValue] * 60 + [jokeSecsLength intValue];
    joke.writeDate = jokeDate;
    joke.uniqueID = [NSNumber numberWithUnsignedInteger:[self.uniqueIDmaxValue intValue] + 1];
    joke.bodyText = bodyText;
    
    [self.jokes addObject:joke];
    
    return joke;
}

- (void) sortJokesArrayWithTwoDescriptors:(NSString *)firstDescriptorString secondDescriptor:(NSString *)secondDescriptorString {
    NSSortDescriptor *scoreSorter = [[NSSortDescriptor alloc]initWithKey:firstDescriptorString ascending:NO];
    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc]initWithKey:secondDescriptorString ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:scoreSorter, dateSorter, nil];
    self.jokes = [[self.jokes sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}




#pragma mark SetCDs-related
- (void) createNewSetInCoreData:(NSString *)setName jokes:(NSMutableArray *)jokes{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetCD" inManagedObjectContext:self.managedObjectContext];
    SetCD *set = [[SetCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    set.name = setName;
    
    //when we create a new set, we find the corresponding cd joke from jokepl and add it to the nsorderedset attribute
    NSMutableArray *jokeCDArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < jokes.count; i++) {
        Joke *joke = jokes[i];
        JokeCD *jokeCD = [self getCorrespondingJokeCDFromJokePL:joke];
        [jokeCDArray addObject:jokeCD];
    }
    
    set.jokes = [NSOrderedSet orderedSetWithArray:[jokeCDArray copy]];
    [self saveChangesInContextCoreData];
}

- (NSMutableArray *) convertCoreDataSetsIntoPresentationLayer: (NSArray *) fetchedCDSetsArray {
    
    NSMutableArray *resultArraySetPLs = [[NSMutableArray alloc]init];
    
    for (int i=0; i < fetchedCDSetsArray.count; i++) {
        SetCD *oneCDSet = fetchedCDSetsArray[i];
        Set *newSet = [[Set alloc]init];
        newSet.name = oneCDSet.name;
        newSet.jokes = [[oneCDSet.jokes array] mutableCopy];
        [resultArraySetPLs addObject:newSet];
    }
    
    return resultArraySetPLs;
}





#pragma mark Other Custom Logic-Related
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
