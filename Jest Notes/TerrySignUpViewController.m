//
//  TerrySignUpViewController.m
//  Jest Notes
//
//  Created by Terry Bu on 1/12/15.
//  Copyright (c) 2015 TerryBuOrganization. All rights reserved.
//

#import "TerrySignUpViewController.h"

@interface TerrySignUpViewController ()

@end

@implementation TerrySignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transparentLogo"]];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.signUpView.logo = logoView; // logo can be any UIView

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
