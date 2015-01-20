//
//  PageRootController.m
//  Jest Notes
//
//  Created by Terry Bu on 12/18/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "RootContainerController.h"

//%%% customizeable button attributes
#define Y_BUFFER 14 //%%% number of pixels on top of the segment
#define HEIGHT 30 //%%% height of the segment
#define ANIMATION_SPEED 0.2 //%%% the number of seconds it takes to complete the animation
#define SELECTOR_HEIGHT 4 //%%% thickness of the selector bar
#define X_OFFSET 12
#define Y_OFFSET_BELOW_NAVBAR 21.7

typedef void (^moveSelectorBarToJokesBlockType)(void);
typedef void (^moveSelectorBarToSetsBlockType)(void);


@interface RootContainerController () {
    NSArray *viewControllers;
    UIView *selectionBar;
    UIButton *leftButton;
    UIButton *rightButton;
    moveSelectorBarToJokesBlockType moveSelectorBarToJokes;
    moveSelectorBarToSetsBlockType moveSelectorBarToSets;
}

@end




@implementation RootContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;

    // Create page view controller
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    viewControllers = @[self.firstVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //not sure why, but if I add "addchildviewcontroller" or "willmovetoview", it will cause a white space inset glitch at top
    //removing it helped make it go away
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self setUpCustomPageControlIndicatorButtons];
    
    [self declareBlocksForConvenience];

}


- (void) declareBlocksForConvenience {
    
    __weak typeof(leftButton) weakLeftButton = leftButton;
    __weak typeof(rightButton) weakRightButton = rightButton;
    __weak typeof(selectionBar) weakSelectionBar = selectionBar;
    __weak typeof(self) weakself = self;
    
    moveSelectorBarToJokes = ^{
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay: 0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             weakLeftButton.backgroundColor = [UIColor orangeColor];
                             weakRightButton.backgroundColor = nil;
                             weakSelectionBar.frame = CGRectMake(0, HEIGHT, weakself.view.frame.size.width/2, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    };
    
    moveSelectorBarToSets =  ^{
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay: 0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             weakRightButton.backgroundColor = [UIColor orangeColor];
                             weakLeftButton.backgroundColor = nil;
                             weakSelectionBar.frame = CGRectMake(weakself.view.frame.size.width/2, HEIGHT, weakself.view.frame.size.width/2 + X_OFFSET, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    };
    
}



- (void) setUpCustomPageControlIndicatorButtons {

        self.pageControlCustomView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR, self.view.frame.size.width, HEIGHT + SELECTOR_HEIGHT))];
    
        leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, HEIGHT)];
        rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.pageControlCustomView.frame.size.width/2, 0, self.view.frame.size.width/2+X_OFFSET, HEIGHT)];
        
        selectionBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + HEIGHT, self.view.frame.size.width/2, SELECTOR_HEIGHT)];
        selectionBar.backgroundColor = [UIColor brownColor];
        selectionBar.alpha = 0.8;
    
        leftButton.tag = 0;
        rightButton.tag = 1;
        
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftButton.layer.borderWidth = 0.8;
        leftButton.layer.borderColor = [UIColor blackColor].CGColor;
        [leftButton addTarget:self action:@selector(tappedJokes:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:@"Jokes" forState:UIControlStateNormal];
        leftButton.backgroundColor = [UIColor orangeColor];

        rightButton.backgroundColor = [UIColor whiteColor];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.layer.borderWidth = 0.8;
        rightButton.layer.borderColor = [UIColor blackColor].CGColor;
        [rightButton addTarget:self action:@selector(tappedSets:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"Sets" forState:UIControlStateNormal];
    
        [self.pageControlCustomView addSubview:leftButton];
        [self.pageControlCustomView addSubview:rightButton];
        [self.pageControlCustomView addSubview:selectionBar];
        [self.pageViewController.view addSubview: self.pageControlCustomView];
}


- (IBAction) tappedJokes:(id)sender {
    [self.pageViewController setViewControllers:@[self.firstVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    leftButton.backgroundColor = [UIColor orangeColor];
    rightButton.backgroundColor = nil;
    
    moveSelectorBarToJokes();

}
- (IBAction) tappedSets:(id)sender {
    [self.pageViewController setViewControllers:@[self.secondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    leftButton.backgroundColor = nil;
    rightButton.backgroundColor = [UIColor orangeColor];
    
    moveSelectorBarToSets();
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        //if you allowed "finished" up in the condition there, the selector bar would move even if you aborted out of the swipe gesture to left or right, causing some mess.
        if (previousViewControllers[0] == self.secondVC) {
            moveSelectorBarToJokes();
        }
        else {
            moveSelectorBarToSets();
        }
    }
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
