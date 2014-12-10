//
//  Set.h
//  Jest Notes
//
//  Created by Terry Bu on 11/7/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Set : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic, strong) NSDate *createDate;
@property (strong, nonatomic) NSMutableArray *jokes;

@property int totalLength;

//this ID is used for matching up presentation and core data layer objects
@property (nonatomic, strong) NSManagedObjectID *managedObjectID;

@end
