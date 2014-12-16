//
//  SetFinalizeViewController.m
//  Jest Notes
//
//  Created by Terry Bu on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SetCreateViewController.h"
#import "Joke.h"
#import "NSObject+NSObject___TerryConvenience.h"
#import "SetCD.h"

@interface SetCreateViewController ()

@end

@implementation SetCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int setLength = 0;
    
    for (int i=0; i < self.selectedJokes.count; i++) {
        Joke *joke = self.selectedJokes[i];
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
    return self.selectedJokes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleCellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]; //this might crash - watch out
    }
    
    Joke *selectedJoke = [self.selectedJokes objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%i. %@", indexPath.row+1, selectedJoke.name];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
}



- (IBAction)createSetButton:(id)sender {
    
    if ([self alertIfSetNameFieldInvalid]) {
        return;
    }
    else {
        
        //First we add it to Presentation Layer
        Set *newSet = [[Set alloc]init];
        newSet.name = self.setNameField.text;
        newSet.jokes = self.selectedJokes;
        newSet.createDate = [NSDate date];
        [self.jokeDataManager.sets addObject:newSet];
        
        //Then we add to Core Data and Parse at the SAME TIME 
        [self.jokeDataManager createNewSetInCoreDataAndParse: newSet];
        
        [self.tabBarController setSelectedIndex:1]; //we are going to sets view right when we are done creating one from the tabbar view
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL) alertIfSetNameFieldInvalid {
    if ([self.setNameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Name Invalid"
                                                        message:@"You need a name for your set"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    return NO;
}


#pragma mark backup reference method .. just in case

//this button can be used in the accessoryView of any tableview row. I was using this before using numbering for multijokes selection for set creation
- (UIButton *) createCustomCheckmarkAccessoryViewWithImage {
    UIImage *image = [UIImage imageNamed:@"checkmark"];
    UIButton *customCheckmarkImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, 24, 24);
    customCheckmarkImageButton.frame = frame;
    [customCheckmarkImageButton setBackgroundImage:image forState:UIControlStateNormal];
    return customCheckmarkImageButton;
}

#pragma mark Keyboard Delegate methods

-(void)dismissKeyboard {
    [self.setNameField resignFirstResponder]; //or whatever your textfield you want this to apply to

}


@end
