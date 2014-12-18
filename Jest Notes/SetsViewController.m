//
//  SetViewController.m
//  Jest Notes
//
//  Created by Terry Bu on 11/21/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SetsViewController.h"
#import "SingleSetViewController.h"

@interface SetsViewController ()

@end

@implementation SetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.jokeDataManager.sets.count > 0) {

        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    }
    
    [self.tableView setContentInset:UIEdgeInsetsMake(34,0,0,0)];


}


- (void) receiveParseSetsFetchDoneNotification:(NSNotification *) notification
{
    NSLog (@"Reload your tableview because parse sets just got delivered");
    [self.tableView reloadData];
}





- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reshowCustomPageControlAndEnableScroling];
    //we need a way to sort the jokes when you created a new joke or edited a joke
    [self.jokeDataManager refreshSetsCDDataWithNewFetch];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.jokeDataManager.sets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    Set *set = [self.jokeDataManager.sets objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"#%i. %@", indexPath.row + 1,set.name];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd/yy"];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:set.createDate]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 20.0 ];
    cell.textLabel.font = myFont;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete from data source
        [self.jokeDataManager deleteSet:indexPath];
        
        // Delete the row visually
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([[segue identifier] isEqualToString:@"singleSetViewSegue"])
    {
        
        [self hideCustomPageControlAndDisableScrolling];
        // Get reference to the destination view controller
        SingleSetViewController *singleSetView = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        singleSetView.selectedSet = [self.jokeDataManager.sets objectAtIndex:indexPath.row];
        singleSetView.title = singleSetView.selectedSet.name;
        singleSetView.jokeDataManager = self.jokeDataManager;
        singleSetView.pageRootController = self.pageRootController;
    }
}



- (void) hideCustomPageControlAndDisableScrolling {
    self.pageRootController.pageControlCustomView.hidden = YES;
    for (UIScrollView *view in self.pageRootController.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = NO;
        }
    }
}

- (void) reshowCustomPageControlAndEnableScroling {
    self.pageRootController.pageControlCustomView.hidden = NO;
    for (UIScrollView *view in self.pageRootController.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = YES;
        }
    }
}



@end
