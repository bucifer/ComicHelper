//
//  JokeCreationViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "CreateJokeViewController.h"
#import "Joke.h"
#import "JokeCD.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface CreateJokeViewController ()

@end



@implementation CreateJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.jokeBodyTextView.layer.borderWidth = 2;
    self.jokeBodyTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    self.nameField.delegate = self;
    self.lengthMinField.delegate = self;
    self.lengthSecondsField.delegate = self;
    self.scoreField.delegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








- (IBAction)createNewJokeAction:(id)sender {
    
    NSString *jokeName = self.nameField.text;
    if ([self nameInputInvalid:jokeName]) {
        return;
        //cuts off the entire IBAction if the alert ever goes up
    }
    
    NSString *jokeScore = self.scoreField.text;
//    if ([self scoreInputInvalid:jokeScore]) {
//        return;
//        //cuts off the entire IBAction if the alert ever goes up
//    }
    
    NSString *jokeMinuteLength = self.lengthMinField.text;
    NSString *jokeSecondsLength = self.lengthSecondsField.text;
    NSDate *myDate = self.writeDatePicker.date;
    
    //When you create a new joke, first you add one to the Presentation Layer by adding it to the  DAO
    Joke *newJoke = [[Joke alloc]init];
    newJoke.name = jokeName;
    newJoke.score = [jokeScore intValue];
    newJoke.length = [jokeMinuteLength intValue] * 60 + [jokeSecondsLength intValue];
    newJoke.writeDate = myDate;
    
    if ([self.jokeBodyTextView.text isEqualToString:@"Tap here to write your joke. Consider using our web application for better joke writing experience!"]) {
        newJoke.bodyText = nil;
    }
    else
        newJoke.bodyText = self.jokeBodyTextView.text;
    
    
    //You create one in presentation layer
    [self.jokeDataManager.jokes addObject: newJoke];
    
    //Then you create one in Core Data and Parse AT THE SAME TIME
    //***Why you might ask? Well, I was worried about the case where the user makes a bunch of jokes and a set OFFLINE in a basement somewhere.
    //If we just saved to Parse, we might lose those jokes, because I couldn't really trust the "saveEventually" functionality of Parse
    //if "saveEventually" works 100%, then I wouldn't have to worry about making my own local cache for Creation logic.
    //But since I'm not so sure, (saveEventually apparently kicks into play automatically next time the user has any internet connection)
    //I'm going to rely on my own custom logic. We are going to add to Local cache anyways, and then next time Parse fetches a whole bunch of stuff, we are going to block it from being converted into Core Data if we find duplicates.
    //This will ABSOLUTELY make sure that no joke or set data gets lost because you didn't have internet connection when you were writing down something
    
    [self.jokeDataManager createNewJokeInCoreDataAndParse:newJoke];

    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Alert view for Input validation checking methods



- (BOOL) nameInputInvalid: (NSString *) jokeName {
    if (jokeName.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No joke title"
                                                        message:@"You need to specify a joke title"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    
    else if ([self.jokeDataManager foundDuplicateJokeNameInCoreData:jokeName]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You already have a joke with the same name"
                                                            message:@"Please name it differently before trying to save."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        return YES;
    }
    
    
    return FALSE;
}


- (BOOL) scoreInputInvalid: (NSString *) scoreString {
    if ([self.jokeDataManager isScoreInputValid:[scoreString intValue]] == NO) {
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


#pragma mark Keyboard Delegate Methods


-(void)dismissKeyboard {
    //dismiss On Tap Somewhere Else
    [self.nameField resignFirstResponder];
    [self.lengthMinField resignFirstResponder];
    [self.lengthSecondsField resignFirstResponder];
    [self.scoreField resignFirstResponder];
    [self.jokeBodyTextView resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}





@end