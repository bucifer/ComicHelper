//
//  InitialCustomViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JokeDataManager.h"

@class JokeDataManager;


@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) JokeDataManager *jokeDataManager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *createNewJokeButton;
@property (strong, nonatomic) IBOutlet UIButton *createNewSetButton;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;

- (IBAction)deleteBarButtonAction:(id)sender;


@end
