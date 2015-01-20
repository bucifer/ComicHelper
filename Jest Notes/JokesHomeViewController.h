//
//  InitialCustomViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "ParseDataManager.h"
#import "RootContainerController.h"

@class CoreDataManager;
@class RootContainerController;

@interface JokesHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ParseDataManagerDelegate>

@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (strong, nonatomic) ParseDataManager *parseDataManager;
@property (weak, nonatomic) RootContainerController *pageRootController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;

- (IBAction)deleteBarButtonAction:(id)sender;



@end
