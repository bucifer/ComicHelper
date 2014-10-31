//
//  EditViewController.h
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Joke.h"

@interface EditViewController : UIViewController

@property (nonatomic, strong) Joke *joke;


@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *lengthMinField;
@property (strong, nonatomic) IBOutlet UITextField *lengthSecondsField;
@property (strong, nonatomic) IBOutlet UITextField *scoreField;
@property (strong, nonatomic) IBOutlet UIDatePicker *creationDatePicker;






@end
