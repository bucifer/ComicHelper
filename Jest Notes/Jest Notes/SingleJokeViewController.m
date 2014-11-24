//
//  SingleJokeViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SingleJokeViewController.h"
#import "EditJokeViewController.h"

@interface SingleJokeViewController ()

@end

@implementation SingleJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self displayMostRecentJokeForUI];
}

- (void) displayMostRecentJokeForUI {
    self.jokeNameLabel.text = self.joke.name;
    
    self.jokeLengthLabel.text = [self turnSecondsIntegerIntoMinuteAndSecondsFormat:self.joke.length];
    
    NSString *score = [NSString stringWithFormat:@"%.01f", self.joke.score];
    self.jokeScoreLabel.text = [NSString stringWithFormat: @"%@ out of 10", score];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    self.jokeDateLabel.text = [dateFormatter stringFromDate:self.joke.creationDate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Navigation 
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"editView"])
    {
        // Get reference to the destination view controller
        EditJokeViewController *evc = [segue destinationViewController];
        evc.jokeDataManager = self.jokeDataManager;
        evc.joke = self.joke;
    }
}


@end
