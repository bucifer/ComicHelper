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
//#define X_OFFSET 12 unnecessary? don't know why i had it in there in the  first place
#define Y_OFFSET_BELOW_NAVBAR 20
//This OFFSET is just for simulators. XCODE has a weird thing about hiding status bars in landscape orientations so in simulators, it looks like our custom pagecontrol breaks alignment but on real hardware device like iPad, it doesn't.

//Keep in mind that a navigation bar's height is 44 pixels
//But the status bar (that says ipad, wifi, time, and battery) is 20 pixels
//So that the complete "header" on top of your viewcontroller is worth 64 pixels in total

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (UIInterfaceOrientationIsLandscape(orientation))
             NSLog(@"landscape width %f", self.view.frame.size.width);
         else if (UIInterfaceOrientationIsPortrait(orientation))
             NSLog(@"portrait width %f", self.view.frame.size.width);
         
        self.pageControlCustomView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR, self.view.frame.size.width, HEIGHT + SELECTOR_HEIGHT);
         leftButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, HEIGHT);
         rightButton.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, HEIGHT);
         
         if (self.pageViewController.viewControllers[0] == self.firstVC)
             selectionBar.frame = CGRectMake(0, HEIGHT, self.view.frame.size.width/2, SELECTOR_HEIGHT);
         else
             selectionBar.frame = CGRectMake(self.view.frame.size.width/2, HEIGHT, self.view.frame.size.width/2, SELECTOR_HEIGHT);
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {

     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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
                             weakSelectionBar.frame = CGRectMake(weakself.view.frame.size.width/2, HEIGHT, weakself.view.frame.size.width/2, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    };
}



- (void) setUpCustomPageControlIndicatorButtons {

        self.pageControlCustomView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR, self.view.frame.size.width, HEIGHT + SELECTOR_HEIGHT))];
        //it's really weird how we need that Y OFFSet. you would think that navbar.frame.size.height will exactly net you rigth below the navbar but instead, it goes a little over the top
    
        leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, HEIGHT)];
        rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, HEIGHT)];
        
        selectionBar = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT, self.view.frame.size.width/2, SELECTOR_HEIGHT)];
        selectionBar.backgroundColor = [UIColor brownColor];
        selectionBar.alpha = 0.8;
        
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
