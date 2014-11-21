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

@interface SetCreateViewController ()  {
    NSMutableArray *searchResults;
    NSMutableArray *selectedObjects;
}

@end

@implementation SetCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if(!cell){
        cell =
        [[JokeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JokeCustomCell"]; //this might crash - watch out
    }
    
    JokePL *joke;
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        //if we are in regular table view
        
        joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        
        if (joke.checkmarkFlag == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //this line solved issue of cells not being selected correctly when we go from "filter tableview" to "regular tableview"
            //the issue happened because whenever we came back to regular table view, the ones that are "checked marked" wouldn't be selected,
            //so "didDESELECT" method wouldn't get properly called when we click on them from reg tableview
        }
        else if (joke.checkmarkFlag == NO) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        //if we are in filter search results view
        joke = [searchResults objectAtIndex:indexPath.row];
        if (joke.checkmarkFlag == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else if (joke.checkmarkFlag == NO) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //to make sure there's no gray highlighting when it's clicked - important
    
    cell.uniqueIDLabel.text = [NSString stringWithFormat:@"#%@", joke.uniqueID];
    cell.titleLabel.text = [NSString stringWithFormat: @"%@", joke.title];
    cell.scoreLabel.text = [NSString stringWithFormat: @"Score: %@", [self quickStringFromInt:joke.score]];
    cell.timeLabel.text = [self turnSecondsIntoReallyShortTimeFormatColon:joke.length];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd/yy"];
    cell.dateLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.creationDate]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
