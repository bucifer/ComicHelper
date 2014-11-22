//
//  SetFinalizeViewController.m
//  Jest Notes
//
//  Created by Terry Bu on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SetFinalizeViewController.h"
#import "JokePL.h"
#import "NSObject+NSObject___TerryConvenience.h"
#import "SetCD.h"

@interface SetFinalizeViewController ()

@end

@implementation SetFinalizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int setLength;
    
    for (int i=0; i < self.jokes.count; i++) {
        JokePL *joke = self.jokes[i];
        setLength += joke.length;
    }
    
    self.setLengthFillLabel.text = [self turnSecondsIntegerIntoMinuteAndSecondsFormat:setLength];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jokes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]; //this might crash - watch out
    }
    
    JokePL *selectedJoke = [self.jokes objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%li. %@", indexPath.row+1, selectedJoke.name];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)createSetButton:(id)sender {
    
    [self.jokeDataManager createNewSetInCoreData: self.setNameField.text];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark Keyboard Delegate methods

-(void)dismissKeyboard {
    [self.setNameField resignFirstResponder]; //or whatever your textfield you want this to apply to

}


@end
