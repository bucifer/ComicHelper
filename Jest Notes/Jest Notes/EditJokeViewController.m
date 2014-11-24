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
    
    self.nameField.text = self.joke.name;
    self.lengthMinField.text = [NSString stringWithFormat:@"%d", (self.joke.length / 60)];
    self.lengthSecondsField.text = [NSString stringWithFormat:@"%d", (self.joke.length % 60)];
    self.scoreField.text = [self quickStringFromInt:self.joke.score];
    
    self.creationDatePicker.datePickerMode = UIDatePickerModeDate;
    self.creationDatePicker.date = self.joke.creationDate;
    
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
    selectedJoke.score = [changedScore floatValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    selectedJoke.creationDate = self.creationDatePicker.date;
    
    [self.jokeDataManager saveEditedJokeInCoreData:selectedJoke title:changedName minLength:changedMinuteLength secLength:changedSecondsLength score:changedScore date:self.creationDatePicker.date];

    [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
