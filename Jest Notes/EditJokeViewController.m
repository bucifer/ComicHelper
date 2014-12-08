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
    
    [self displayMostRecentJokeForUI];
}

- (void) displayMostRecentJokeForUI {
    self.nameField.text = self.joke.name;
    self.lengthMinField.text = [NSString stringWithFormat:@"%d", (self.joke.length / 60)];
    self.lengthSecondsField.text = [NSString stringWithFormat:@"%d", (self.joke.length % 60)];
    self.scoreField.text = [self quickStringFromInt:self.joke.score];
    
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


- (IBAction)saveButtonAction:(id)sender {
    NSString *changedName = self.nameField.text;
    NSString *changedScore = self.scoreField.text;
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
    
    [self.jokeDataManager saveEditedJokeInCoreData:selectedJoke];

    [self.navigationController popToRootViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Keyboard and TextView Delegate methods

-(void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.lengthMinField resignFirstResponder];
    [self.lengthSecondsField resignFirstResponder];
    [self.scoreField resignFirstResponder];
    [self.bodyTextView resignFirstResponder];
}

@end
