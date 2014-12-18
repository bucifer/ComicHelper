//
//  SetToJokeDetailViewController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/4/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SetToJokeDetailViewController.h"

@interface SetToJokeDetailViewController ()

@end

@implementation SetToJokeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.joke.name;
    
    self.jokeBodyTextView.text = self.joke.bodyText;
    
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
