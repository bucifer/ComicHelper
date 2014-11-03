//
//  Joke.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Joke : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * title;

@end
