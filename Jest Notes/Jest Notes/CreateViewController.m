//
//  JokeCreationViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "CreateViewController.h"
#import "Joke.h"
#import "JokeCD.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    self.creationDatePicker.datePickerMode = UIDatePickerModeDate;
    
    self.jokeBodyTextField.layer.borderWidth = 2;
    self.jokeBodyTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createNewJokeAction:(id)sender {
    
    NSString *jokeName = self.nameField.text;
    if (jokeName.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No joke title"
                                                        message:@"You need to specify a joke title"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *jokeScore = self.scoreField.text;
    if ([self alertIfInvalid:jokeScore]) {
        return; //cuts off and interrupts create new action if the alert ever goes up
    }
    NSString *jokeMinuteLength = self.lengthMinField.text;
    NSString *jokeSecondsLength = self.lengthSecondsField.text;
    NSDate *myDate = self.creationDatePicker.date;
    
    [self.jokeDataManager createNewJokeInPresentationLayer:jokeName jokeScore:jokeScore jokeMinLength:jokeMinuteLength jokeSecsLength:jokeSecondsLength jokeDate:myDate];
    [self.jokeDataManager createNewJokeInCoreData:jokeName jokeScore:jokeScore jokeMinLength:jokeMinuteLength jokeSecsLength:jokeSecondsLength jokeDate:myDate];
    
    [self.navigationController popViewControllerAnimated:YES];
}







- (BOOL) alertIfInvalid: (NSString *) scoreString {
    if ([self.jokeDataManager isScoreInputValid:[scoreString floatValue]] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score out of range"
                                                        message:@"Your score input is out of range. Please input a number between 0 to 10 (inclusive) under Joke Score"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    return FALSE;
}




#pragma mark Keyboard Delegate methods

-(void)dismissKeyboard {
    [self.nameField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.lengthMinField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.scoreField resignFirstResponder]; //or whatever your textfield you want this to apply to
    
}




@end