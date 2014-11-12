//
//  JokeDataManager.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "JokeDataManager.h"
#import "JokeCD.h"
#import "JokePL.h"

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
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        //        Specify criteria for filtering which objects to fetch
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
        //        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *scoreSort = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
        NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                       ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:scoreSort, dateSort, nil]];
        
        NSError *error = nil;
        NSArray *fetchedJokesFromCD = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedJokesFromCD == nil) {
            NSLog(@"some horrible error in fetching CD: %@", error);
        }
        
        self.jokes = [self convertCoreDataJokesArrayIntoJokePLs:fetchedJokesFromCD];
        [self.hvc.tableView reloadData];
        
    }
}

- (NSMutableArray *) convertCoreDataJokesArrayIntoJokePLs: (NSArray *) fetchedObjectsArrayOfCDJokes {
    
    NSMutableArray *resultArrayOfJokePLs = [[NSMutableArray alloc]init];
    
    for (int i=0; i < fetchedObjectsArrayOfCDJokes.count; i++) {
        JokeCD *oneCDJoke = fetchedObjectsArrayOfCDJokes[i];
        JokePL *newPLJoke = [[JokePL alloc]init];
        newPLJoke.title = oneCDJoke.title;
        newPLJoke.score = [oneCDJoke.score floatValue];
        newPLJoke.length = [oneCDJoke.length intValue];
        newPLJoke.creationDate = oneCDJoke.creationDate;
        newPLJoke.managedObjectID = [oneCDJoke objectID];
        newPLJoke.uniqueID = oneCDJoke.uniqueID;
        [resultArrayOfJokePLs addObject:newPLJoke];
    }
    
    return resultArrayOfJokePLs;
}

- (JokePL *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke {
    JokePL *newPLJoke = [[JokePL alloc]init];
    newPLJoke.title = oneCoreDataJoke.title;
    newPLJoke.score = [oneCoreDataJoke.score floatValue];
    newPLJoke.length = [oneCoreDataJoke.length intValue];
    newPLJoke.creationDate = oneCoreDataJoke.creationDate;
    newPLJoke.managedObjectID = [oneCoreDataJoke objectID];
    newPLJoke.uniqueID = oneCoreDataJoke.uniqueID;

    return newPLJoke;
}




- (void) saveEditedJokeInCoreData: (JokePL *) jokePL title:(NSString*)title minLength:(NSString*)minLength secLength:(NSString*)secLength score:(NSString*)score date: (NSDate *) date{
    NSError *error;
    JokeCD *correspondingCDJoke = (JokeCD *) [self.managedObjectContext existingObjectWithID:jokePL.managedObjectID error:&error];
    correspondingCDJoke.title = title;
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



- (void) createNewJokeInCoreData: (NSString *) jokeTitle jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    joke.title = jokeTitle;
    joke.length = [NSNumber numberWithInt: ([jokeMinuteLength intValue] * 60 + [jokeSecsLength intValue])];
    joke.score = [NSNumber numberWithFloat:[jokeScore floatValue]];
    joke.creationDate = jokeDate;
    joke.uniqueID = [NSNumber numberWithUnsignedInteger:[self.uniqueIDmaxValue intValue] + 1];
    [self saveChangesInContextCoreData];
}





#pragma mark Logic-Related


- (NSNumber *) returnUniqueID {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedJokesFromCD = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedJokesFromCD == nil) {
        NSLog(@"error in fetching CD: %@", error);
    }
    
    NSNumber *maxValue = nil;
    if (fetchedJokesFromCD)
        if ([fetchedJokesFromCD valueForKeyPath:@"@max.uniqueID.unsignedIntegerValue"] != nil)
            maxValue = [fetchedJokesFromCD valueForKeyPath:@"@max.uniqueID.unsignedIntegerValue"];
        else
            maxValue = [NSNumber numberWithUnsignedInteger:0];
    else
        maxValue = [NSNumber numberWithUnsignedInteger:0];
    
    self.uniqueIDmaxValue = maxValue;
    return maxValue;
}


- (void) sortJokesArrayWithTwoDescriptors:(NSString *)firstDescriptorString secondDescriptor:(NSString *)secondDescriptorString {
    NSSortDescriptor *scoreSorter = [[NSSortDescriptor alloc]initWithKey:firstDescriptorString ascending:NO];
    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc]initWithKey:secondDescriptorString ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:scoreSorter, dateSorter, nil];
    self.jokes = [[self.jokes sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (BOOL) isScoreInputValid: (float) score {
    if (score > 10 || score < 0) {
        return FALSE;
    }
    return TRUE;
}



@end
