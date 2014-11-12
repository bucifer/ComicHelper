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


@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) JokeDataManager *jokeDataManager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) IBOutlet UIButton *createNewJokeButton;
@property (strong, nonatomic) IBOutlet UIButton *createNewSetButton;




- (IBAction)editButtonAction:(id)sender;


@end
