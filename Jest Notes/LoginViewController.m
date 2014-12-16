//
//  LoginViewController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/15/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"comedy.jpg" ]];
//    [self.view addSubview:backgroundView];
    
    UIImage *myLogoImage = [UIImage imageNamed:@"transparentLogoBigger"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:myLogoImage];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.clipsToBounds = YES;
    
    self.logInView.logo = logoView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //this is how you redesign the loginview in terms of style
//    self.logInView.logInButton.frame = CGRectMake(150, 400, 100, 50); // set a different frame.
    [self.logInView.logInButton setBackgroundColor:[UIColor orangeColor]];
    
    //apparently Parse put a gray background image on that login button .. you gotta remove it for the background color to show properly
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];

}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
