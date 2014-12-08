//
//  JokeCD.h
//  Jest Notes
//
//  Created by Aditya Narayan on 12/8/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SetCD;

@interface JokeCD : NSManagedObject

@property (nonatomic, retain) NSString * bodyText;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * writeDate;
@property (nonatomic, retain) NSString * parseObjectID;
@property (nonatomic, retain) NSSet *set;
@end

@interface JokeCD (CoreDataGeneratedAccessors)

- (void)addSetObject:(SetCD *)value;
- (void)removeSetObject:(SetCD *)value;
- (void)addSet:(NSSet *)values;
- (void)removeSet:(NSSet *)values;

@end
