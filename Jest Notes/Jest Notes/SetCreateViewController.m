//
//  SetCreateViewController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 11/20/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SetCreateViewController.h"
#import "JokeCustomCell.h"
#import "NSObject+NSObject___TerryConvenience.h"
#import "ViewManager.h"
#import <QuartzCore/QuartzCore.h>

@interface SetCreateViewController ()  {
    NSMutableArray *searchResults;
    NSMutableArray *selectedObjects;
    ViewManager *viewManager;
}

@end

@implementation SetCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Setting up searchbar filter functionality
    searchResults = [NSMutableArray arrayWithCapacity:[self.jokeDataManager.jokes count]];
    selectedObjects = [[NSMutableArray array]init];
    self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = YES;
    
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshSetSelectionAction:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    
    NSArray *buttonArray = [NSArray arrayWithObjects:doneButton, clearButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    
    viewManager = [[ViewManager alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Search Bar Methods
- (void)filterContentForSearchText:(NSString*)searchText scope: (NSString *) scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH[cd] %@", searchText];
    searchResults = [[self.jokeDataManager.jokes filteredArrayUsingPredicate:resultPredicate]mutableCopy];
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [tableView reloadData];
    [self.tableView reloadData];
    //these two lines make sure that both Filterview and Tableview data are refreshed - without it, it doesn't work
}



#pragma mark tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return self.jokeDataManager.jokes.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleCellIdentifier = @"JokeCustomCell";
    
    JokePL *joke;
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        //if we are in regular table view
        JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
        if(!cell){
            cell =
            [[JokeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JokeCustomCell"]; //this might crash - watch out
        }
        joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        cell.uniqueIDLabel.text = [NSString stringWithFormat:@"#%@", joke.uniqueID];
        cell.titleLabel.text = [NSString stringWithFormat: @"%@", joke.title];
        cell.scoreLabel.text = [NSString stringWithFormat: @"Score: %@", [self quickStringFromInt:joke.score]];
        cell.timeLabel.text = [self turnSecondsIntoReallyShortTimeFormatColon:joke.length];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/dd/yy"];
        cell.dateLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.creationDate]];
        if (joke.checkmarkFlag == YES) {
            cell.accessoryView = [viewManager createCustomCheckmarkAccessoryViewWithImage];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //this line solved issue of cells not being selected correctly when we go from "filter tableview" to "regular tableview"
            //the issue happened because whenever we came back to regular table view, the ones that are "checked marked" wouldn't be selected,
            //so "didDESELECT" method wouldn't get properly called when we click on them from reg tableview
        }
        else if (joke.checkmarkFlag == NO) {
            cell.accessoryView = nil;
        }
        //Background color for selection
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [viewManager colorWithHexString:@"ffe700"];
        [cell setSelectedBackgroundView:bgColorView];
        return cell;
    }
    else {
        //if we are in filter search results view
        UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(!cell){
            cell =
            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]; //this might crash - watch out
        }
        joke = [searchResults objectAtIndex:indexPath.row];

        //Fill in the cell with data
        cell.textLabel.text = joke.title;
        
        //Background color for selection
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [viewManager colorWithHexString:@"ffe700"];
        [cell setSelectedBackgroundView:bgColorView];
        
        //checkmark logic
        cell.accessoryView = (joke.checkmarkFlag == YES) ? [viewManager createCustomCheckmarkAccessoryViewWithImage] : nil;

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        [self didSelectCheckmarkLogicForSearchFilterView:indexPath cell:cell];
    }
    else {
        [self didSelectCheckmarkLogicForRegularTableView:indexPath cell:cell];
    }
    
    cell.tintColor = [UIColor blackColor];
    [self logWhatsBeenSelected];
}

- (void) didSelectCheckmarkLogicForSearchFilterView: (NSIndexPath *)indexPath cell: (UITableViewCell*) cell{
    //if its filterview mode
    JokePL *selectedJoke = [searchResults objectAtIndex:indexPath.row];
    if (selectedJoke.checkmarkFlag == YES) {
        selectedJoke.checkmarkFlag = NO;
        cell.accessoryView = nil;
        [selectedObjects removeObject:selectedJoke];
    }
    else {
        selectedJoke.checkmarkFlag = YES;
        cell.accessoryView = [viewManager createCustomCheckmarkAccessoryViewWithImage];
        [selectedObjects addObject:selectedJoke];
    }
}

- (void) didSelectCheckmarkLogicForRegularTableView: (NSIndexPath *)indexPath cell: (UITableViewCell*) cell{

    //if we are in regular tableview mode
    JokePL *selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
    selectedJoke.checkmarkFlag = YES;
    
    UIButton *jokeOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jokeOrderButton.frame = CGRectMake(0.0f, 0.0f, 32, 32);
    jokeOrderButton.layer.cornerRadius = jokeOrderButton.bounds.size.width / 3;
    jokeOrderButton.layer.borderWidth = 3;
    jokeOrderButton.layer.borderColor = [[UIColor blackColor]CGColor];
    [jokeOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jokeOrderButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    
    NSUInteger selectedObjectsCount = selectedObjects.count + 1;
    
    [jokeOrderButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)selectedObjectsCount] forState:UIControlStateNormal];
    
    cell.accessoryView = jokeOrderButton;
    [selectedObjects addObject:selectedJoke];

}

- (void) logWhatsBeenSelected {
    
    for (int i=0; i < selectedObjects.count; i++) {
        JokePL *joke = selectedObjects[i];
        NSLog(@"%@", joke.title);
    }
    NSLog(@"\n");
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JokePL *selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
    selectedJoke.checkmarkFlag = NO;
    cell.accessoryView = nil;

    [selectedObjects removeObject:selectedJoke];
    
    NSLog(@"%@", selectedObjects);
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                           ascending:YES
                                                                            selector:@selector(localizedCaseInsensitiveCompare:)];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [self.jokeDataManager.jokes sortedArrayUsingDescriptors:sortDescriptors];
            self.jokeDataManager.jokes = [sortedArray mutableCopy];
            [self.tableView reloadData];
            break;
        }
        case 2: {
            [self sortYourJokesArrayWithDescriptor:@"creationDate" ascending:NO];
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
    NSArray *sortedArray = [self.jokeDataManager.jokes sortedArrayUsingDescriptors:sortDescriptors];
    self.jokeDataManager.jokes = [sortedArray mutableCopy];
    [self.tableView reloadData];
}


- (IBAction)refreshSetSelectionAction:(id)sender {
    
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row ++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        JokePL *selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        selectedJoke.checkmarkFlag = NO;
        cell.accessoryView = nil;
        [selectedObjects removeObject:selectedJoke];
    }
    
}


- (IBAction)doneAction:(id)sender {
    
    if (selectedObjects.count == 0)
        NSLog(@"Nothing Selected");
    else {
        for (int i=0; i < selectedObjects.count; i++) {
            JokePL *oneJoke = selectedObjects[i];
            NSLog(@"%@", oneJoke.title);
        }
    }
}

@end
