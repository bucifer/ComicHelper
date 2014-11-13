//
//  HomeViewController.m
//  Multi-SelectWithOrdering
//
//  Created by Aditya Narayan on 11/13/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeViewController.h"
#import "Fruit.h"

@interface HomeViewController () {
    NSMutableArray *dataArray;
    NSMutableArray *fruitsArray;
    NSMutableArray *searchResults;
    NSMutableArray *selectedObjects;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    fruitsArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]initWithObjects:@"Apple", @"Grape", @"Blueberry", @"Strawberry", @"Banana", @"Mango", @"Pineapple", @"Watermelon", nil];
    
    for (int i=0; i < dataArray.count; i++) {
        Fruit *fruit = [[Fruit alloc]init];
        fruit.name = dataArray[i];
        [fruitsArray addObject:fruit];
    }
    
    //Setting up searchbar filter functionality
    searchResults = [NSMutableArray arrayWithCapacity:[fruitsArray count]];
    selectedObjects = [[NSMutableArray array]init];
    self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Search Bar Methods
- (void)filterContentForSearchText:(NSString*)searchText scope: (NSString *) scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", searchText];
    searchResults = [[fruitsArray filteredArrayUsingPredicate:resultPredicate]mutableCopy];
    NSLog(searchResults.description);
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [tableView reloadData];
//    [self.tableView reloadData];
    
    //these two lines make sure that both Filterview and Tableview data are refreshed - without it, it doesn't work
}





#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return fruitsArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] name];
    }
    else {
        cell.textLabel.text = [[fruitsArray objectAtIndex:indexPath.row] name];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
