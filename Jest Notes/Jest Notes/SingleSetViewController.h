//
//  SingleSetViewController.h
//  Jest Notes
//
//  Created by Aditya Narayan on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCD.h"

@interface SingleSetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SetCD *selectedSet;


@end
