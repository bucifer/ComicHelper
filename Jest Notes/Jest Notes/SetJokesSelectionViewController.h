//
//  SetCreateViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/20/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"

@interface SetJokesSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchControllerDelegate>

@property (strong, nonatomic) JokeDataManager *jokeDataManager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)segCtrlAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
