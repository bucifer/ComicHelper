//
//  InitialCustomViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateViewController.h"
#import "SingleJokeViewController.h"
#import "JokePL.h"
#import "JokeCD.h"
#import "Set.h"

#import "JokeCustomCell.h"
#import "NSObject+NSObject___TerryConvenience.h"

@interface HomeViewController ()

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.jokeDataManager appInitializationLogic];
    
    self.createNewJokeButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.createNewSetButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData]; // to reload selected cell
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *myArray = @[@"Jokes", @"Sets"];
    return [myArray objectAtIndex:section];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch(section){
        case 0:
            return self.jokeDataManager.jokes.count;
        case 1:
            return self.jokeDataManager.sets.count;
    }
    return self.jokeDataManager.jokes.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    switch([indexPath section]){
        case 0: {
            //we are in Jokes section
            
            static NSString *simpleCellIdentifier = @"JokeCustomCell";
            JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
            
            if (self.jokeDataManager.jokes.count > 0 ) {
                JokePL *joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
                cell.titleLabel.text = [NSString stringWithFormat: @"%@", joke.title];
                cell.scoreLabel.text = [NSString stringWithFormat: @"Score: %@", [self quickStringFromInt:joke.score]];
                cell.timeLabel.text = [self turnSecondsIntoReallyShortTimeFormatColon:joke.length];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"M/dd/yy"];
                cell.dateLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.creationDate]];
                return cell;
            }
        }
        case 1: {
            //we are in Set section
            if (self.jokeDataManager.sets.count > 0) {
                
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                Set *set = [self.jokeDataManager.sets objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat: @"%@", set.name];
                return cell;
            }
            
        }
    }

    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support deleting on swipe of the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        JokePL *selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        
        JokeCD *correspondingCDJoke = (JokeCD*) [self.jokeDataManager.managedObjectContext existingObjectWithID:selectedJoke.managedObjectID error:nil];
        [self.jokeDataManager.managedObjectContext deleteObject:correspondingCDJoke];
        [self.jokeDataManager saveChangesInContextCoreData];

        [self.jokeDataManager.jokes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"creation"])
    {
        // Get reference to the destination view controller
        CreateViewController *cvc = [segue destinationViewController];
        cvc.jokeDataManager = self.jokeDataManager;
    }
    else if ([[segue identifier] isEqualToString:@"singleView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SingleJokeViewController *sjvc = [segue destinationViewController];
        JokePL *selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        sjvc.joke  = selectedJoke;
        sjvc.title = selectedJoke.title;
        sjvc.jokeDataManager = self.jokeDataManager;
    }
    
}



- (IBAction)editButtonAction:(id)sender {

    if(self.tableView.editing){
        [self.tableView setEditing: NO animated: YES];
    }
    else {
        [self.tableView setEditing: YES animated: YES];
    }
}


@end
