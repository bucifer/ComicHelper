//
//  InitialCustomViewController.m
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "InitialCustomViewController.h"

@interface InitialCustomViewController ()

@end

@implementation InitialCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createNewJokeButton.layer.cornerRadius = 5;
    self.createNewJokeButton.layer.borderWidth = 2;
    self.createNewJokeButton.layer.borderColor = [UIColor blackColor].CGColor;

    
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
