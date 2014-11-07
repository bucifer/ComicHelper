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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveButtonAction:(id)sender {
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
    
    //now we need to edit the core data. If we don't, it will revert back to core data (pre-edit) version once you quit out of app
    //to match this particular presentation layer joke with its appropriate core data joke object, we can predicate using name
    //but that doesn't guarantee uniqueness
    //so we use unique managedObjectID (that comes by default in any managed object)
    //we are going to set a property with the presentation layer and save it to it as soon as it comes out of the oven converted
    
    [self saveEditedJokeInCoreData:selectedJoke title:changedTitle minLength:changedMinuteLength secLength:changedSecondsLength score:changedScore

    [self.navigationController popViewControllerAnimated:YES];
}

     - (void) saveEditedJokeInCoreData: (JokePL *) jokePL title:(NSString*)title minLength:(NSString*)minLength secLength:(NSString*)secLength score:(NSString*)score date:  {
    NSError *error;
    JokeCD *correspondingCDJoke = (JokeCD *) [self.jokeDataManager.managedObjectContext existingObjectWithID:jokePL.managedObjectID error:&error];
    correspondingCDJoke.title = title;
    correspondingCDJoke.length = [NSNumber numberWithInt:([minLength intValue] * 60 + [secLength intValue])];
    correspondingCDJoke.score = [NSNumber numberWithInt:[score intValue]];
    correspondingCDJoke.creationDate = self.creationDatePicker.date;
    [self.jokeDataManager saveChangesInCoreData];
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
