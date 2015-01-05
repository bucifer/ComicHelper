//
//  HomeTabBarController.m
//  Jest Notes
//
//  Created by Terry Bu on 12/8/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeTabBarController.h"
#import "PageRootController.h"
#import "SetsViewController.h"
#import "JokeDataManager.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializationLogic];

}

- (void) initializationLogic {
    JokeDataManager *jokeDataManager = [[JokeDataManager alloc]init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    jokeDataManager.managedObjectContext = [appDelegate managedObjectContext];
    
    UINavigationController *firstNavController = self.viewControllers[0];
    
    PageRootController *pageRootController = (PageRootController *) firstNavController.topViewController;
    HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    homeViewController.jokeDataManager = jokeDataManager;
    homeViewController.pageRootController = pageRootController;
    SetsViewController *svc = (SetsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SetsViewController"];
    svc.jokeDataManager = jokeDataManager;
    svc.pageRootController = pageRootController;
    [self addUniqueObserver:svc selector:@selector(receiveParseSetsFetchDoneNotification:) name:@"ParseSetsFetchDone" object:nil];
    
    UINavigationController *firstVCNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"firstVCNavController"];
    UINavigationController *secondVCNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondVCNavController"];
    
    firstVCNavController.viewControllers = @[homeViewController];
    secondVCNavController.viewControllers = @[svc];
    
    pageRootController.firstVC = firstVCNavController;
    pageRootController.secondVC = secondVCNavController;
   
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
