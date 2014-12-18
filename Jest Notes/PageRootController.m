//
//  PageRootController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 12/18/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "PageRootController.h"

//%%% customizeable button attributes
#define Y_BUFFER 14 //%%% number of pixels on top of the segment
#define HEIGHT 30 //%%% height of the segment

//%%% customizeable selector bar attributes (the black bar under the buttons)
#define ANIMATION_SPEED 0.2 //%%% the number of seconds it takes to complete the animation
#define SELECTOR_Y_BUFFER 40 //%%% the y-value of the bar that shows what page you are on (0 is the top)
#define SELECTOR_HEIGHT 4 //%%% thickness of the selector bar

#define X_OFFSET 12 //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future
#define Y_OFFSET_BELOW_NAVBAR 22


@interface PageRootController () {

    NSArray *viewControllers;
    UIView *pageControlCustomView;
    UIView *selectionBar;
    int SELECTOR_WIDTH;
    int SELECTOR_Y;
}

@end




@implementation PageRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    SELECTOR_WIDTH = self.view.frame.size.width/2;
    SELECTOR_Y = self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR + HEIGHT;
    
    self.navigationController.navigationBarHidden = YES;
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.backgroundColor = [UIColor clearColor];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    viewControllers = @[self.firstVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    [self setUpCustomPageControlIndicatorButtons];
}

- (void) viewWillDisappear:(BOOL)animated {
    pageControlCustomView.hidden = YES;
}



- (void) setUpCustomPageControlIndicatorButtons {

        pageControlCustomView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR, self.view.frame.size.width, HEIGHT + SELECTOR_HEIGHT))];
    
        UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, pageControlCustomView.frame.size.width/2, HEIGHT)];
        UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(pageControlCustomView.frame.size.width/2, 0, self.view.frame.size.width/2+X_OFFSET, HEIGHT)];
        
        selectionBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + HEIGHT, SELECTOR_WIDTH, SELECTOR_HEIGHT)];
        selectionBar.backgroundColor = [UIColor lightGrayColor];
        selectionBar.alpha = 0.8;
    
        leftButton.tag = 0;
        rightButton.tag = 1;
        
        leftButton.backgroundColor = [UIColor whiteColor];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftButton.layer.borderWidth = 0.8;
        leftButton.layer.borderColor = [UIColor blackColor].CGColor;
        [leftButton addTarget:self action:@selector(tappedJokes:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:@"Jokes" forState:UIControlStateNormal];

        rightButton.backgroundColor = [UIColor whiteColor];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.layer.borderWidth = 0.8;
        rightButton.layer.borderColor = [UIColor blackColor].CGColor;
        [rightButton addTarget:self action:@selector(tappedSets:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"Sets" forState:UIControlStateNormal];
    
        [pageControlCustomView addSubview:leftButton];
        [pageControlCustomView addSubview:rightButton];
        [pageControlCustomView addSubview:selectionBar];
        [self.pageViewController.view addSubview: pageControlCustomView];
}

- (IBAction) tappedJokes:(id)sender {
    [self.pageViewController setViewControllers:@[self.firstVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    [UIView animateWithDuration: ANIMATION_SPEED
                          delay:0.1
                        options: nil
                     animations:^{
                         
                         selectionBar.frame = CGRectMake(0, HEIGHT, SELECTOR_WIDTH, SELECTOR_HEIGHT);
                     }
                     completion:^(BOOL finished){
                     }];

}
- (IBAction) tappedSets:(id)sender {
    [self.pageViewController setViewControllers:@[self.secondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [UIView animateWithDuration: ANIMATION_SPEED
                          delay:0.1
                        options: nil
                     animations:^{
                         
                         selectionBar.frame = CGRectMake(SELECTOR_WIDTH, HEIGHT, SELECTOR_WIDTH + X_OFFSET, SELECTOR_HEIGHT);
                     }
                     completion:^(BOOL finished){
                     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == self.secondVC)
        return self.firstVC;
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == self.firstVC)
        return self.secondVC;
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    
    if (pendingViewControllers[0] == self.secondVC) {
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay:0.1
                            options: nil
                         animations:^{
                             
                             selectionBar.frame = CGRectMake(SELECTOR_WIDTH, HEIGHT, SELECTOR_WIDTH + X_OFFSET, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else {
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay:0.1
                            options: nil
                         animations:^{
                             
                             selectionBar.frame = CGRectMake(0, HEIGHT, SELECTOR_WIDTH, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    }

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
