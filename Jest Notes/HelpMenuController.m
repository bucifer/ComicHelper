//
//  HelpMenuController.m
//  Jest Notes
//
//  Created by Terry Bu on 11/25/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HelpMenuController.h"

@interface HelpMenuController ()

@end

@implementation HelpMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.helpManualTextView.textContainerInset = UIEdgeInsetsZero;

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
