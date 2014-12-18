//
//  PageRootController.h
//  Jest Notes
//
//  Created by Aditya Narayan on 12/18/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "SetsViewController.h"

@interface PageRootController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) SetsViewController *setsViewController;


//for pageview
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
