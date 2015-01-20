//
//  PageRootController.h
//  Jest Notes
//
//  Created by Terry Bu on 12/18/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokesHomeViewController.h"
#import "SetsViewController.h"

@interface RootContainerController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (strong, nonatomic) UINavigationController *firstVC;
@property (strong, nonatomic) UINavigationController *secondVC;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIView *pageControlCustomView;

@end
