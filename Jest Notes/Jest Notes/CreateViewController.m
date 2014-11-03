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
    NSString *jokeScore = self.scoreField.text;
    NSString *jokeMinuteLength = self.lengthMinField.text;
    NSString *jokeSecondsLength = self.lengthSecondsField.text;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.jokeDataManager.managedObjectContext];
    JokeCD *joke = [[JokeCD alloc] initWithEntity:entity insertIntoManagedObjectContext:self.jokeDataManager.managedObjectContext];
    joke.title = jokeTitle;
    joke.length = [NSNumber numberWithInt: ([jokeMinuteLength intValue] * 60 + [jokeSecondsLength intValue])];
    joke.score = [NSNumber numberWithInt:[jokeScore intValue]];
    joke.creationDate = self.creationDatePicker.date;
    [self.jokeDataManager saveChangesInCoreData];
    
    //For presentation layer
    //If you don't have this logic, when you create a joke, it won't show up on tableview right afterwards ... and only show up when you relaunch and refetch from Core Data. You don't want that
    
    [self.jokeDataManager.jokes addObject:[self.jokeDataManager convertCoreDataJokeIntoPresentationLayerJoke:joke]];
    
    
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