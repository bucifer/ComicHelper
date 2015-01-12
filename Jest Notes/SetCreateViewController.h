//
//  SetFinalizeViewController.h
//  Jest Notes
//
//  Created by Terry Bu on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

@interface SetCreateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectedJokes;
@property (strong, nonatomic) CoreDataManager *coreDataManager;

@property (strong, nonatomic) IBOutlet UITextField *setNameField;
@property (strong, nonatomic) IBOutlet UILabel *setLengthFillLabel;

- (IBAction)createSetButton:(id)sender;

@end
