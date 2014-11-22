//
//  Joke.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/23/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JokePL : NSObject

@property (nonatomic, strong) NSString* title;
@property float score;
@property int length;
@property (nonatomic, strong) NSDate *creationDate;
//this uniqueID is used for User Interface purposes (joke #4) so that people can easily identify their jokes
@property (nonatomic, strong) NSNumber *uniqueID;


//this ID is used for matching up presentation and core data layer objects
@property (nonatomic, strong) NSManagedObjectID *managedObjectID;

//this checkmarkFlag is used to Set Creation view to see if one's been checked off or not
@property BOOL checkmarkFlag;
//for Set Creation View, a joke would have this?? not sure yet 
@property NSUInteger setOrder;


@end
