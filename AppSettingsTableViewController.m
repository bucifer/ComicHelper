//
//  AppSettingsTableViewController.m
//  
//
//  Created by Aditya Narayan on 12/18/14.
//
//

#import "AppSettingsTableViewController.h"
#import <Parse/Parse.h>
#import "HomeTabBarController.h"

@interface AppSettingsTableViewController ()

@end

@implementation AppSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender {
    NSLog(@"%@", [PFUser currentUser]);
    [PFUser logOut]; // Log out
    UINavigationController *navCtrl = self.navigationController;
    HomeTabBarController *htbc = (HomeTabBarController *) navCtrl.tabBarController;
    [htbc dismissViewControllerAnimated:NO completion:^{
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.center=self.view.center;
        
        [activityView startAnimating];
        
        [self.view addSubview:activityView];
        
    }];
}

@end
