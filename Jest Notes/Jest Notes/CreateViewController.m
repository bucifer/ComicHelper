//
//  JokeCreationViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "CreateViewController.h"
#import "JokePL.h"
#import "JokeCD.h"

@interface CreateViewController () {
    NSString *temporaryStoredDate;
}

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createNewJokeAction:(id)sender {
    
    NSString *jokeTitle = self.titleField.text;
    if (jokeTitle.length <= 0) {
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
    
    [self createNewJokeInPresentationLayer:jokeTitle jokeScore:jokeScore jokeMinLength:jokeMinuteLength jokeSecsLength:jokeSecondsLength jokeDate:myDate];
    [self.jokeDataManager createNewJokeInCoreData:jokeTitle jokeScore:jokeScore jokeMinLength:jokeMinuteLength jokeSecsLength:jokeSecondsLength jokeDate:myDate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (JokePL *) createNewJokeInPresentationLayer: (NSString *) jokeTitle jokeScore: (NSString *) jokeScore jokeMinLength: (NSString *) jokeMinuteLength jokeSecsLength: (NSString *) jokeSecsLength jokeDate: (NSDate *) jokeDate {
    JokePL *joke = [[JokePL alloc]init];
    joke.title = jokeTitle;
    joke.score = [jokeScore floatValue];
    joke.length = [jokeMinuteLength intValue] * 60 + [jokeSecsLength intValue];
    joke.creationDate = jokeDate;
    joke.uniqueID = [NSNumber numberWithUnsignedInteger:[self.jokeDataManager.uniqueIDmaxValue intValue] + 1];

    [self.jokeDataManager.jokes addObject:joke];
    
    return joke;
}





- (BOOL) alertIfInvalid: (NSString *) scoreString {
    int tempScoreStore = [scoreString floatValue];
    if ([self.jokeDataManager isScoreInputValid:tempScoreStore] == FALSE) {
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
    [self.titleField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.lengthMinField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.scoreField resignFirstResponder]; //or whatever your textfield you want this to apply to
    
}




@end