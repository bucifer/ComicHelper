//
//  EditViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "EditViewController.h"
#import "JokePL.h"
#import "JokeCD.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleField.text = self.joke.title;
    self.lengthMinField.text = [NSString stringWithFormat:@"%d", (self.joke.length / 60)];
    self.lengthSecondsField.text = [NSString stringWithFormat:@"%d", (self.joke.length % 60)];
    self.scoreField.text = [self quickStringFromInt:self.joke.score];
    
    self.creationDatePicker.datePickerMode = UIDatePickerModeDate;
    self.creationDatePicker.date = self.joke.creationDate;
    
}

- (void)editSaveAction {
    
    NSString *changedTitle = self.titleField.text;
    NSString *changedScore = self.scoreField.text;
    NSString *changedMinuteLength = self.lengthMinField.text;
    NSString *changedSecondsLength = self.lengthSecondsField.text;
    
    //editing presentation layer joke
    JokePL *selectedJoke = self.joke;
    selectedJoke.title = changedTitle;
    selectedJoke.length = [changedMinuteLength intValue] * 60 + [changedSecondsLength intValue];
    selectedJoke.score = [changedScore intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    selectedJoke.creationDate = self.creationDatePicker.date;
    //now we need to edit the core data. If we don't, it will revert back to core data version once you quit out of app
    
    NSError *error;
    JokeCD *correspondingCDJoke = (JokeCD *) [self.jokeDataManager.managedObjectContext objectWithID:selectedJoke.managedObjectID];    
    correspondingCDJoke.title = changedTitle;
    correspondingCDJoke.length = [NSNumber numberWithInt:([changedMinuteLength intValue] * 60 + [changedSecondsLength intValue])];
    correspondingCDJoke.score = [NSNumber numberWithInt:[changedScore intValue]];
    correspondingCDJoke.creationDate = self.creationDatePicker.date;
    [self.jokeDataManager saveChangesInCoreData];
    
    NSLog(@"Joke Edited");
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
