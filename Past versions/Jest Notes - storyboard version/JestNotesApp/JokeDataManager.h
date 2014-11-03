//
//  JokeDataManager.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JokePL.h"




@interface JokeDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *jokes;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;







@end
