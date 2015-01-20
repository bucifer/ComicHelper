//
//  SetViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/21/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "RootContainerController.h"

@class RootContainerController;

@interface SetsViewController : UITableViewController

@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (weak, nonatomic) RootContainerController *pageRootController;


- (void) receiveParseSetsFetchDoneNotification:(NSNotification *) notification;


@end
