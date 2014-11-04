//
//  JokeCustomCell.h
//  Jest Notes
//
//  Created by Aditya Narayan on 11/4/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface JokeCustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) HomeViewController *tableViewController;

@end
