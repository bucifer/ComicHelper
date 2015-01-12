//
//  InitialCustomViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import "ParseDataManager.h"
#import <Parse/Parse.h>
#import "CreateJokeViewController.h"
#import "SingleJokeViewController.h"
#import "MultiJokesSelectionController.h"
#import "Joke.h"
#import "JokeCD.h"
#import "JokeParse.h"
#import "JokeCustomCell.h"
#import "Set.h"
#import "SetsViewController.h"
#import "HomeTabBarController.h"
#import "NSObject+NSObject___TerryConvenience.h"
#import "PageRootController.h"

@class CoreDataManager;
@class PageRootController;

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ParseDataManagerDelegate>

@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (strong, nonatomic) ParseDataManager *parseDataManager;
@property (weak, nonatomic) PageRootController *pageRootController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;

- (IBAction)deleteBarButtonAction:(id)sender;



@end
