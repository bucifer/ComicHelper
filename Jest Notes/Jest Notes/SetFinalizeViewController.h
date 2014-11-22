//
//  SetFinalizeViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"

@interface SetFinalizeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *jokes;
@property (strong, nonatomic) IBOutlet UITextField *setNameField;
@property (strong, nonatomic) IBOutlet UILabel *setLengthFillLabel;
@property (strong, nonatomic) JokeDataManager *jokeDataManager;

- (IBAction)createSetButton:(id)sender;

@end
