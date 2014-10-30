//
//  JokeCreationViewController.m
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "JokeCreationViewController.h"
#import "Joke.h"

@interface JokeCreationViewController ()

@end

@implementation JokeCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveAction:(id)sender {
    
    NSString *jokeTitle = self.jokeTitleTextField.text;
    NSString *jokeLength = self.jokeLengthTextField.text;
    NSString *jokeScore = self.jokeScoreTextField.text;
    
    Joke *newJoke = [[Joke alloc]init];
    newJoke.title = jokeTitle;
    newJoke.length = [jokeLength intValue];
    newJoke.score = [jokeScore intValue];
    
    [self.jokeDataManager.jokes addObject:newJoke];
    NSLog(@"New joke saved");
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Keyboard Delegate methods

-(void)dismissKeyboard {
    [self.jokeTitleTextField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.jokeLengthTextField resignFirstResponder]; //or whatever your textfield you want this to apply to
    [self.jokeScoreTextField resignFirstResponder]; //or whatever your textfield you want this to apply to
}




@end