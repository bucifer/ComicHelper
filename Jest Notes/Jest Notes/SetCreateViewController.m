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
    //Setting up searchbar filter functionality
    searchResults = [NSMutableArray arrayWithCapacity:[self.jokeDataManager.jokes count]];
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
            cell.accessoryView = [self createCustomCheckmarkAccessoryViewWithImage];
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
        bgColorView.backgroundColor = [self colorWithHexString:@"ffe700"];
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
        bgColorView.backgroundColor = [self colorWithHexString:@"ffe700"];
        [cell setSelectedBackgroundView:bgColorView];
        
        //checkmark logic
        cell.accessoryView = (joke.checkmarkFlag == YES) ? [self createCustomCheckmarkAccessoryViewWithImage] : nil;

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JokePL *selectedJoke;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        //if its filterview mode
        selectedJoke = [searchResults objectAtIndex:indexPath.row];
        if (selectedJoke.checkmarkFlag == YES) {
            selectedJoke.checkmarkFlag = NO;
            cell.accessoryView = nil;
            [selectedObjects removeObject:selectedJoke];
        }
        else {
            selectedJoke.checkmarkFlag = YES;
            cell.accessoryView = [self createCustomCheckmarkAccessoryViewWithImage];
            [selectedObjects addObject:selectedJoke];
        }
    }
    else {
        //if we are in regular tableview mode
        selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        selectedJoke.checkmarkFlag = YES;
        cell.accessoryView = [self createCustomCheckmarkAccessoryViewWithImage];
        [selectedObjects addObject:selectedJoke];
    }
    
    cell.tintColor = [UIColor blackColor];
    NSLog(@"%@", selectedObjects);
}

- (UIButton *) createCustomCheckmarkAccessoryViewWithImage {
    UIImage *image = [UIImage imageNamed:@"checkmark"];
    UIButton *customCheckmarkImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, 24, 24);
    customCheckmarkImageButton.frame = frame;
    [customCheckmarkImageButton setBackgroundImage:image forState:UIControlStateNormal];
    return customCheckmarkImageButton;
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


- (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
