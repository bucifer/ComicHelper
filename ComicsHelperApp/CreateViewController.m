//
//  JokeCreationViewController.m
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "CreateViewController.h"
#import "Joke.h"

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


- (IBAction)saveAction:(id)sender {
    
    NSString *jokeTitle = self.titleField.text;
    NSString *jokeScore = self.scoreField.text;
    NSString *jokeMinuteLength = self.lengthMinField.text;
    NSString *jokeSecondsLength = self.lengthSecondsField.text;
    
    Joke *newJoke = [[Joke alloc]init];
    newJoke.title = jokeTitle;
    newJoke.length = [jokeMinuteLength intValue] * 60 + [jokeSecondsLength intValue];
    newJoke.score = [jokeScore intValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    newJoke.creationDate = self.creationDatePicker.date;
    
    [self.jokeDataManager.jokes addObject:newJoke];
    NSLog(@"New joke saved");
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Keyboard Delegate methods

-(void)dismissKeyboard {
    [self.titleField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.lengthMinField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.scoreField resignFirstResponder]; //or whatever your textfield you want this to apply to
    
}




@end