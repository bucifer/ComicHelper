//
//  SingleJokeViewController.m
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SingleJokeViewController.h"

@interface SingleJokeViewController ()

@end

@implementation SingleJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.jokeTitleLabel.text = self.joke.title;
    
    
    self.jokeLengthLabel.text = [self turnSecondsIntegerIntoMinuteAndSecondsFormat:self.joke.length];
    
    
    NSString *score = [NSString stringWithFormat:@"%d", self.joke.score];
    self.jokeScoreLabel.text = [NSString stringWithFormat: @"%@ out of 10", score];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    self.jokeDateLabel.text = [dateFormatter stringFromDate:self.joke.creationDate];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *) turnSecondsIntegerIntoMinuteAndSecondsFormat: (int) seconds {
    
    int minutes = seconds / 60;
    int secondsLeftover = seconds % 60;
    
    if (minutes == 0) {
        return [NSString stringWithFormat:@"%d seconds", seconds];
    }
    else if (minutes == 1) {
        return [NSString stringWithFormat:@"1 minute %d seconds", secondsLeftover];
    }
    
    return [NSString stringWithFormat:@"%d minutes %d seconds", minutes, secondsLeftover];
    
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
