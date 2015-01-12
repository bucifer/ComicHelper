//
//  SetCreateViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/20/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

@interface MultiJokesSelectionController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchControllerDelegate>

@property (strong, nonatomic) CoreDataManager *coreDataManager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)segCtrlAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
