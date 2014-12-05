//
//  ParseDataManager.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/5/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "ParseDataManager.h"
#import <Parse/Parse.h>
#import "JokeParse.h"

@implementation ParseDataManager

- (void) getAllParseJokes {
    PFQuery *query = [PFQuery queryWithClassName:@"Joke"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu jokes from Parse server", objects.count);
            // Do something with the found objects
            
            for (JokeParse *jokeParse in objects) {
                NSLog(@"%@", jokeParse.objectId);
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

@end
