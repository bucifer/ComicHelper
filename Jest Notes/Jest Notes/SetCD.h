//
//  SetCD.h
//  Jest Notes
//
//  Created by Aditya Narayan on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JokeCD;

@interface SetCD : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSSet *jokes;

@end



@interface SetCD (CoreDataGeneratedAccessors)

- (void)addJokesObject:(JokeCD *)value;
- (void)removeJokesObject:(JokeCD *)value;
- (void)addJokes:(NSSet *)values;
- (void)removeJokes:(NSSet *)values;

@end
