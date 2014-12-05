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
            
            for (JokeParse *jokeParse in objects) {
                NSLog(@"%@", jokeParse.objectId);
                [self convertParseJokeToCoreData:jokeParse];
            }
            
            [self.delegate parseDataManagerDidFinishGettingAllParseJokes];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}


- (void) convertParseJokeToCoreData: (JokeParse *) jokeParse {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    joke.name = jokeParse.name;
    joke.length = jokeParse.length;
    joke.score = jokeParse.score;
    joke.writeDate = jokeParse.writeDate;
    joke.bodyText = jokeParse.bodyText;
//    joke.uniqueID = [self returnUniqueIDmaxValue];
    [self saveChangesInContextCoreData];
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
    
    return maxValue;
}

@end
