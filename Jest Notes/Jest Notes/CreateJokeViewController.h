//
//  JokeCreationViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"

@interface CreateJokeViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *lengthMinField;
@property (strong, nonatomic) IBOutlet UITextField *lengthSecondsField;
@property (strong, nonatomic) IBOutlet UITextField *scoreField;
@property (strong, nonatomic) IBOutlet UIDatePicker *writeDatePicker;
@property (strong, nonatomic) IBOutlet UITextView *jokeBodyTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) JokeDataManager *jokeDataManager;

- (IBAction)createNewJokeAction:(id)sender;

@end
