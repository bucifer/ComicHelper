//
//  LoginViewController.m
//  Jest Notes
//
//  Created by Terry Bu on 12/15/14.
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
    
    UIImage *myLogoImage = [UIImage imageNamed:@"logoBannerWithLogoIconforLoginView"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:myLogoImage];
    logoView.contentMode = UIViewContentModeScaleToFill;
    logoView.clipsToBounds = YES;
    
    self.logInView.logo = logoView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.logInView.logInButton setBackgroundColor:[UIColor orangeColor]];
    
    //apparently Parse put a gray background image on that login button .. you gotta remove it for the background color to show properly
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];

    //this is how you redesign the loginview in terms of style
    //    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
        [self.logInView.logo setFrame:CGRectMake(self.view.frame.size.width/2-243/2, 70.0f, 243, 114)];
    //    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
    //    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
    //    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    //    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    //    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
