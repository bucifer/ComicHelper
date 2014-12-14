//
//  SetViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/21/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"

@interface SetsViewController : UITableViewController

@property (strong, nonatomic) JokeDataManager *jokeDataManager;



- (void) receiveParseSetsFetchDoneNotification:(NSNotification *) notification;



@end
