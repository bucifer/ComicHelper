//
//  HomeTabBarController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/8/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeTabBarController.h"
#import "SetsViewController.h"
#import "JokeDataManager.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSwipeGestureFunctionalityForMovingAcrossPages];
    //soon to be removed if you ever implement that pageviewcontrol instead
    
    [self initializationLogic];

}

- (void) initializationLogic {
    JokeDataManager *jokeDataManager = [[JokeDataManager alloc]init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    jokeDataManager.managedObjectContext = [appDelegate managedObjectContext];
    
    UINavigationController *firstNavController = self.viewControllers[0];
    HomeViewController *hvc = (HomeViewController *) firstNavController.topViewController;
    hvc.jokeDataManager = jokeDataManager;
    
    UINavigationController *secondNavController = self.viewControllers[1];
    SetsViewController *svc = (SetsViewController *) secondNavController.topViewController;
    svc.jokeDataManager = jokeDataManager;
    
    [self addUniqueObserver:svc selector:@selector(receiveParseSetsFetchDoneNotification:) name:@"ParseSetsFetchDone" object:nil];
   
}

- (void)addUniqueObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object {
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
    
}

- (void) setUpSwipeGestureFunctionalityForMovingAcrossPages {

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];

}

- (IBAction)tappedRightButton:(id)sender
{
    NSUInteger selectedIndex = [self selectedIndex];
    
    [self setSelectedIndex:selectedIndex + 1];
}

- (IBAction)tappedLeftButton:(id)sender
{
    NSUInteger selectedIndex = [self selectedIndex];
    
    [self setSelectedIndex:selectedIndex - 1];
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
