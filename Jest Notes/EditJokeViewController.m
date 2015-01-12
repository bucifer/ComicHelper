//
//  EditViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "EditJokeViewController.h"
#import "Joke.h"
#import "JokeCD.h"

@interface EditJokeViewController ()

@end

@implementation EditJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.nameField.delegate = self;
    self.lengthMinField.delegate = self;
    self.lengthSecondsField.delegate = self;
    
    [self displayMostRecentJokeForUI];
}

- (void) displayMostRecentJokeForUI {
    
    self.nameField.text = self.joke.name;
    
    if (self.joke.length / 60 == 0) {
        self.lengthMinField.text = nil;
    }
    else {
        self.lengthMinField.text = [NSString stringWithFormat:@"%d", (self.joke.length / 60)];
    }
    
    self.lengthSecondsField.text = [NSString stringWithFormat:@"%d", (self.joke.length % 60)];
    
    self.scoreOutOfTenLabel.text = [NSString stringWithFormat:@"Joke Score (%d out of 10)", self.joke.score];
    self.scoreSlider.value = (float) self.joke.score;
    
    self.bodyTextView.text = self.joke.bodyText;
    self.bodyTextView.layer.borderWidth = 2;
    self.bodyTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.writeDatePicker.datePickerMode = UIDatePickerModeDate;
    self.writeDatePicker.date = self.joke.writeDate;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderValueChanged:(id)sender {
    self.scoreOutOfTenLabel.text = [NSString stringWithFormat:@"Joke Score (%d out of 10)", (int) self.scoreSlider.value];
}

- (IBAction)saveButtonAction:(id)sender {
    NSString *tempOldNameStringForParseMatching = self.joke.name;
    
    NSString *changedName = self.nameField.text;
    NSString *changedScore = [[NSNumber numberWithFloat:self.scoreSlider.value] stringValue];
    NSString *changedMinuteLength = self.lengthMinField.text;
    NSString *changedSecondsLength = self.lengthSecondsField.text;
    
    //editing presentation layer joke
    Joke *selectedJoke = self.joke;
    selectedJoke.name = changedName;
    selectedJoke.length = [changedMinuteLength intValue] * 60 + [changedSecondsLength intValue];
    selectedJoke.score = [changedScore intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    selectedJoke.writeDate = self.writeDatePicker.date;
    selectedJoke.bodyText = self.bodyTextView.text;
    
    [self.coreDataManager editJokeInCoreDataAndParse:selectedJoke tempOldNameStringForParseMatching:tempOldNameStringForParseMatching];


    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark Keyboard and TextView Delegate methods

-(void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.lengthMinField resignFirstResponder];
    [self.lengthSecondsField resignFirstResponder];
    [self.bodyTextView resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

@end
