//
//  SingleSetViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Set.h"
#import "CoreDataManager.h"
#import "RootContainerController.h"

@interface SingleSetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Set *selectedSet;
@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (weak, nonatomic) RootContainerController *pageRootController;


@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)editButton:(UIBarButtonItem *)sender;

@end
