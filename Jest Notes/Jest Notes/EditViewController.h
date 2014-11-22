//
//  EditViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokeDataManager.h"
#import "NSObject+NSObject___TerryConvenience.h"

@interface EditViewController : UIViewController

@property (nonatomic, strong) JokePL *joke;


@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *lengthMinField;
@property (strong, nonatomic) IBOutlet UITextField *lengthSecondsField;
@property (strong, nonatomic) IBOutlet UITextField *scoreField;
@property (strong, nonatomic) IBOutlet UIDatePicker *creationDatePicker;
@property (strong, nonatomic) JokeDataManager *jokeDataManager;


- (IBAction)saveButtonAction:(id)sender;




@end
