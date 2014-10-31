//
//  JokeDataManager.h
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JokeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokes;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
