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
    if ( self = [super init] ) {
        self.jokes = [[NSMutableArray alloc]init];
    }
    return self;
}

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
        
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                       ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
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
        newPLJoke.score = [oneCDJoke.score intValue];
        newPLJoke.length = [oneCDJoke.length intValue];
        newPLJoke.creationDate = oneCDJoke.creationDate;
        newPLJoke.managedObjectID = [oneCDJoke objectID];
        [resultArrayOfJokePLs addObject:newPLJoke];
    }
    
    return resultArrayOfJokePLs;
}

- (JokePL *) convertCoreDataJokeIntoPresentationLayerJoke: (JokeCD *) oneCoreDataJoke {
    JokePL *newPLJoke = [[JokePL alloc]init];
    newPLJoke.title = oneCoreDataJoke.title;
    newPLJoke.score = [oneCoreDataJoke.score intValue];
    newPLJoke.length = [oneCoreDataJoke.length intValue];
    newPLJoke.creationDate = oneCoreDataJoke.creationDate;
    newPLJoke.managedObjectID = [oneCoreDataJoke objectID];
    
    return newPLJoke;
}


- (void) saveChangesInCoreData {
        NSError *err = nil;
        BOOL successful = [self.managedObjectContext save:&err];
        if(!successful){
            NSLog(@"Error saving: %@", [err localizedDescription]);
        } else {
            NSLog(@"Core Data Saved without errors - reporting from JokeDataManager");
        }
}


@end
