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

@interface CreateJokeViewController () {
    NSString* placeHolderStringForTextView;
}

@end



@implementation CreateJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.jokeBodyTextView.layer.borderWidth = 2;
    self.jokeBodyTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    placeHolderStringForTextView = @"Tap here to write your joke. Consider using our web application for better joke writing experience!";
    
    self.jokeBodyTextView.text = placeHolderStringForTextView;
    self.jokeBodyTextView.textColor = [UIColor lightGrayColor]; //optional
    self.jokeBodyTextView.delegate = self;
    
    self.scoreField.delegate = self;
    
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
    if ([self alertScoreInputInvalid:jokeScore]) {
        return; //cuts off and interrupts create new action if the alert ever goes up
    }
    NSString *jokeMinuteLength = self.lengthMinField.text;
    NSString *jokeSecondsLength = self.lengthSecondsField.text;
    NSDate *myDate = self.writeDatePicker.date;
    
    [self.jokeDataManager createNewJokeInPresentationLayer:jokeName jokeScore:jokeScore jokeMinLength:jokeMinuteLength jokeSecsLength:jokeSecondsLength jokeDate:myDate bodyText:self.jokeBodyTextView.text];
    [self.jokeDataManager createNewJokeInCoreData:jokeName jokeScore:jokeScore jokeMinLength:jokeMinuteLength jokeSecsLength:jokeSecondsLength jokeDate:myDate bodyText:self.jokeBodyTextView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (BOOL) alertScoreInputInvalid: (NSString *) scoreString {
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




#pragma mark Keyboard and TextView Delegate methods

-(void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.lengthMinField resignFirstResponder];
    [self.lengthSecondsField resignFirstResponder];
    [self.scoreField resignFirstResponder];
    [self.jokeBodyTextView resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, self.scoreField.frame.origin.y-220);
    [self.myScrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.myScrollView setContentOffset:CGPointZero animated:YES];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([textView.text isEqualToString:placeHolderStringForTextView] && [textView.textColor isEqual:[UIColor lightGrayColor]])[textView setSelectedRange:NSMakeRange(0, 0)];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [textView setSelectedRange:NSMakeRange(0, 0)];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0 && [[textView.text substringFromIndex:1] isEqualToString:placeHolderStringForTextView] && [textView.textColor isEqual:[UIColor lightGrayColor]]){
        textView.text = [textView.text substringToIndex:1];
        textView.textColor = [UIColor blackColor]; //optional
        
    }
    else if(textView.text.length == 0){
        textView.text = placeHolderStringForTextView;
        textView.textColor = [UIColor lightGrayColor];
        [textView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeHolderStringForTextView;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length > 1 && [textView.text isEqualToString:placeHolderStringForTextView]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}



@end