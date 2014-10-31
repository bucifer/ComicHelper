//
//  JokeCreationViewController.h
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"

@interface CreateViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *lengthMinField;
@property (strong, nonatomic) IBOutlet UITextField *lengthSecondsField;
@property (strong, nonatomic) IBOutlet UITextField *scoreField;
@property (strong, nonatomic) IBOutlet UIDatePicker *creationDatePicker;


@property (strong, nonatomic) JokeDataManager *jokeDataManager;

- (IBAction)saveAction:(id)sender;

@end
