//
//  JokeCD.h
//  Jest Notes
//
//  Created by Aditya Narayan on 11/12/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JokeCD : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * uniqueID;

@end
