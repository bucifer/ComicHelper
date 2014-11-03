//
//  InitialCustomViewController.h
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"
#import "CreateViewController.h"
#import "SingleJokeViewController.h"
#import "Joke.h"


@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>



@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) JokeDataManager *jokeDataManager;
@property (strong, nonatomic) IBOutlet UIButton *createNewJokeButton;




@end