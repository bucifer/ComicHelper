//
//  SetCD.h
//  Jest Notes
//
//  Created by Terry Bu on 12/16/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JokeCD;

@interface SetCD : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSOrderedSet *jokes;
@end

@interface SetCD (CoreDataGeneratedAccessors)

- (void)insertObject:(JokeCD *)value inJokesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromJokesAtIndex:(NSUInteger)idx;
- (void)insertJokes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeJokesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInJokesAtIndex:(NSUInteger)idx withObject:(JokeCD *)value;
- (void)replaceJokesAtIndexes:(NSIndexSet *)indexes withJokes:(NSArray *)values;
- (void)addJokesObject:(JokeCD *)value;
- (void)removeJokesObject:(JokeCD *)value;
- (void)addJokes:(NSOrderedSet *)values;
- (void)removeJokes:(NSOrderedSet *)values;
@end
