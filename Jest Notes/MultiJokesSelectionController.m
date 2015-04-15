//
//  SetCreateViewController.m
//  Jest Notes
//
//  Created by Terry Bu on 11/20/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "MultiJokesSelectionController.h"
#import "JokeCustomCell.h"
#import "NSObject+NSObject___TerryConvenience.h"
#import <QuartzCore/QuartzCore.h>
#import "Set.h"
#import "SetCreateViewController.h"
#import "UIColor+UIColor_Additions.h"

@interface MultiJokesSelectionController ()  {
    NSMutableArray *searchResults;
    NSMutableArray *selectedObjects;
}

- (IBAction)segCtrlAction:(id)sender;


@end

@implementation MultiJokesSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];

    searchResults = [[NSMutableArray array]init];
    selectedObjects = [[NSMutableArray array]init];
    self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = YES;
    [self initializeBarButtons];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:item];
}


- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coreDataManager.jokes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        //we are in regular table view
        static NSString *jokeCustomCellIdentifier = @"JokeCustomCell";
        JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:jokeCustomCellIdentifier];
        if(!cell){
            cell =
            [[JokeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jokeCustomCellIdentifier];
        }
        [self cellStylingLogicForRegTableView:cell indexPath:indexPath];
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JokeCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self didSelectCheckmarkLogicForRegularTableView:indexPath cell:cell];
    cell.tintColor = [UIColor blackColor];
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    JokeCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Joke *selectedJoke = [self.coreDataManager.jokes objectAtIndex:indexPath.row];
    [self jokeWasDeselected:selectedJoke];
    cell.accessoryView = nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}




#pragma mark Refactored Methods

- (void) initializeBarButtons {
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshSetSelectionAction)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    NSArray *buttonArray = [NSArray arrayWithObjects:doneButton, clearButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
}


#pragma mark Refactored TableView methods
- (void) cellStylingLogicForFilterView: (UITableViewCell *) cell indexPath:(NSIndexPath *)indexPath {
    Joke *joke = [searchResults objectAtIndex:indexPath.row];
    
    //Fill in the cell with data
    cell.textLabel.text = joke.name;
    
    //Background color for selection -- we do it separately for searchview and tableview because we are not using JokeCustomCell for this filterview
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:@"ffe700"];
    [cell setSelectedBackgroundView:bgColorView];
    
    //checkmark logic
    cell.accessoryView = (joke.checkmarkFlag == YES) ? [self createJokeOrderButtonForJoke:joke] : nil;
}

- (void) cellStylingLogicForRegTableView: (JokeCustomCell *) cell indexPath:(NSIndexPath *)indexPath {
    
    Joke *joke = [self.coreDataManager.jokes objectAtIndex:indexPath.row];
    cell.uniqueIDLabel.text = [NSString stringWithFormat:@"#%@", joke.uniqueID];
    cell.nameLabel.text = [NSString stringWithFormat: @"%@", joke.name];
    cell.scoreLabel.text = [NSString stringWithFormat: @"Score: %@", [self quickStringFromInt:joke.score]];
    cell.timeLabel.text = [self turnSecondsIntoReallyShortTimeFormatColon:joke.length];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd/yy"];
    cell.dateLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.writeDate]];
    if (joke.checkmarkFlag == YES) {
        cell.accessoryView = [self createJokeOrderButtonForJoke: joke];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //this line solved issue of cells not being selected correctly when we go from "filter tableview" to "regular tableview"
        //the issue happened because whenever we came back to regular table view, the ones that are "checked marked" wouldn't be selected,
        //so "didDESELECT" method wouldn't get properly called when we click on them from reg tableview
    }
    else if (joke.checkmarkFlag == NO) {
        cell.accessoryView = nil;
    }
    //Background color for selection
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithHexString:@"ffe700"];
    [cell setSelectedBackgroundView:bgColorView];
}

- (void) didSelectCheckmarkLogicForSearchFilterView: (NSIndexPath *)indexPath cell: (UITableViewCell*) cell{
    //if its filterview mode
    Joke *selectedJoke = [searchResults objectAtIndex:indexPath.row];
    if (selectedJoke.checkmarkFlag == YES) {
        [self jokeWasDeselected:selectedJoke];
        cell.accessoryView = nil;
    }
    else {
        //if it was never selected before,
        [self jokeWasSelected:selectedJoke];
        cell.accessoryView = [self createJokeOrderButtonForJoke: selectedJoke];
    }
}

- (void) didSelectCheckmarkLogicForRegularTableView: (NSIndexPath *)indexPath cell: (UITableViewCell*) cell{
    Joke *selectedJoke = [self.coreDataManager.jokes objectAtIndex:indexPath.row];
    [self jokeWasSelected:selectedJoke];
    cell.accessoryView = [self createJokeOrderButtonForJoke:selectedJoke];
}

- (void) jokeWasSelected: (Joke*) selectedJoke {
    selectedJoke.checkmarkFlag = YES;
    
    //the order the joke will possess in the set - is the order in which you've placed it into the selected objects array
    //when the array is empty, the set order defaults to #1
    //when it's not, the joke's set order is selectedObjects.count + 1
    selectedJoke.setOrder = selectedObjects ? selectedObjects.count + 1 : 1;
    [selectedObjects addObject:selectedJoke];
}

- (void) jokeWasDeselected: (Joke*) selectedJoke {
    selectedJoke.checkmarkFlag = NO;
    [selectedObjects removeObject:selectedJoke];
}

- (UIButton *) createJokeOrderButtonForJoke: (Joke*) joke {
    UIButton *jokeOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jokeOrderButton.frame = CGRectMake(0.0f, 0.0f, 32, 32);
    jokeOrderButton.layer.cornerRadius = jokeOrderButton.bounds.size.width / 3;
    jokeOrderButton.layer.borderWidth = 3;
    jokeOrderButton.layer.borderColor = [[UIColor blackColor]CGColor];
    [jokeOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jokeOrderButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [jokeOrderButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)joke.setOrder] forState:UIControlStateNormal];
    
    return jokeOrderButton;
}

- (void) logWhatsBeenSelected {
    
    for (int i=0; i < selectedObjects.count; i++) {
        Joke *joke = selectedObjects[i];
        NSLog(@"%@", joke.name);
    }
    NSLog(@"\n");
}




#pragma mark IBAction methods

- (IBAction)segCtrlAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    switch (selectedSegment) {
        case 0: {
            [self sortYourJokesArrayWithDescriptor:@"uniqueID" ascending:YES];
            break;
        }
        case 1: {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                           ascending:YES
                                                                            selector:@selector(localizedCaseInsensitiveCompare:)];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [self.coreDataManager.jokes sortedArrayUsingDescriptors:sortDescriptors];
            self.coreDataManager.jokes = [sortedArray mutableCopy];
            [self.tableView reloadData];
            break;
        }
        case 2: {
            [self sortYourJokesArrayWithDescriptor:@"writeDate" ascending:NO];
            break;
        }
        default:
            break;
    }

}

- (void) sortYourJokesArrayWithDescriptor: (NSString *) descriptor ascending: (BOOL) ascending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:descriptor
                                                                   ascending:ascending
                                        ];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.coreDataManager.jokes sortedArrayUsingDescriptors:sortDescriptors];
    self.coreDataManager.jokes = [sortedArray mutableCopy];
    [self.tableView reloadData];
}


- (void) refreshSetSelectionAction {
    
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row ++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        Joke *selectedJoke = [self.coreDataManager.jokes objectAtIndex:indexPath.row];
        selectedJoke.checkmarkFlag = NO;
        cell.accessoryView = nil;
        [selectedObjects removeObject:selectedJoke];
    }
    
}


- (void)doneAction {
    if (selectedObjects.count == 0) {
        NSLog(@"Nothing Selected");
        [self alertIfNothingWasSelected];
        return;
    }
    
    [self performSegueWithIdentifier:@"setFinalizeViewSegue" sender:self];
}

- (void) alertIfNothingWasSelected {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select at least 1 joke"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"setFinalizeViewSegue"])
    {
        // Get reference to the destination view controller
        SetCreateViewController *scvc = [segue destinationViewController];
        scvc.selectedJokes = selectedObjects;
        scvc.coreDataManager = self.coreDataManager;
    }
}



@end
