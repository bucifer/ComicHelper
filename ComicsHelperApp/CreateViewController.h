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


@property (strong, nonatomic) IBOutlet UITextField *jokeTitleTextField;

@property (strong, nonatomic) IBOutlet UITextField *jokeLengthMinuteTextField;
@property (strong, nonatomic) IBOutlet UITextField *jokeLengthSecondsTextField;

@property (strong, nonatomic) IBOutlet UITextField *jokeScoreTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *jokeCreationDatePicker;


@property (strong, nonatomic) JokeDataManager *jokeDataManager;

- (IBAction)saveAction:(id)sender;

@end
