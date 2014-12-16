//
//  SettingsViewController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/16/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    
}


- (IBAction)logOutButton:(id)sender {
    
    NSLog(@"%@", [PFUser currentUser]);
    
    [PFUser logOut]; // Log out
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

@end
