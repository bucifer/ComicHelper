//
//  AppSettingsTableViewController.m
//  
//
//  Created by Terry Bu on 12/18/14.
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
    NSLog(@"LOG OUTTTT %@", [PFUser currentUser]);
    [PFUser logOut]; // Log out
    [self.navigationController.tabBarController dismissViewControllerAnimated:YES completion: nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self logout: nil];
    
}

@end
