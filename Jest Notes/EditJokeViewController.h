//
//  EditViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "NSObject+NSObject___TerryConvenience.h"

@interface EditJokeViewController : UIViewController <UITextFieldDelegate> 

@property (nonatomic, strong) Joke *joke;


@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *lengthMinField;
@property (strong, nonatomic) IBOutlet UITextField *lengthSecondsField;
@property (strong, nonatomic) IBOutlet UIDatePicker *writeDatePicker;
@property (strong, nonatomic) IBOutlet UISlider *scoreSlider;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;


@property (strong, nonatomic) IBOutlet UILabel *scoreOutOfTenLabel;
@property (strong, nonatomic) CoreDataManager *coreDataManager;

- (IBAction)sliderValueChanged:(id)sender;

- (IBAction)saveButtonAction:(id)sender;




@end
