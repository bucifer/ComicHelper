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





@end