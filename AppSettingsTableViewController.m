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
#import <Social/Social.h>


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


- (void)logout {
    [PFUser logOut]; // Log out
    [self.navigationController.tabBarController dismissViewControllerAnimated:YES completion: nil];
}

- (void)email {
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:@"[Jest Notes Support Email]"];
    
    /* define email address */
    NSString *mail = [NSString stringWithFormat:@"ktbucifer@gmail.com"];
    
    /* create the URL */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    /* load the URL */
    [[UIApplication sharedApplication] openURL:url];
}

- (void) alertForSocial: (NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)facebook {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbPreview = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPreview setInitialText:@"Are you a stand-up comic? I'm using Jest Notes iOS app to organize my jokes and sets!"];
        [fbPreview addURL:[NSURL URLWithString:@"http://www.jestnotesapp.com"]];
        [fbPreview addImage:[UIImage imageNamed:@"squiggly180x180noTransparent"]];
        [self presentViewController:fbPreview animated:YES completion:Nil];
    }
    else {
        [self alertForSocial:@"You must be logged into Facebook in social service of your phone's device settings"];
    }

}

- (void)twitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetComposeView = [SLComposeViewController
                                                     composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetComposeView setInitialText:@"Are you a stand-up comic? I'm using Jest Notes iOS app to organize my jokes and sets!"];
        [tweetComposeView addURL:[NSURL URLWithString:@"http://www.jestnotesapp.com"]];
        [tweetComposeView addImage:[UIImage imageNamed:@"squiggly180x180noTransparent"]];
        [self presentViewController:tweetComposeView animated:YES completion:nil];
    }
    else {
        [self alertForSocial:@"You must be logged into Twitter in social service of your phone's device settings"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self logout];
            break;
        case 1:
            [self email];
            break;
        case 2:
            [self facebook];
            break;
        case 3:
            [self twitter];
            break;
        default:
            break;
    }
    

    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = [NSString stringWithFormat:@"current user: %@", [PFUser currentUser].username];
            break;
        default:
            break;
    }
    return sectionName;
}


@end
