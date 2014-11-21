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
#import "SetCreateViewController.h"

@interface HomeViewController ()

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.jokeDataManager appInitializationLogic];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    
    UIBarButtonItem *addJokeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addJokeButtonAction)];
    UIBarButtonItem *addSetButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addSetButtonAction)];

    
    NSArray *buttonArray = [NSArray arrayWithObjects:addJokeButton, addSetButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //we need a way to sort the jokes when you created a new joke or edited a joke
    
    [self.jokeDataManager refreshDataWithNewFetch];
    [self.jokeDataManager sortArrayWithOneDescriptorString:self.jokeDataManager.jokes descriptor:@"uniqueID" ascending:YES];
    [self.tableView reloadData];
    
    if (self.jokeDataManager.jokes.count == 0)
        self.deleteBarButton.title = nil;
    else if (self.jokeDataManager.jokes.count > 0)
        self.deleteBarButton.title = @"Delete";
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
    return self.jokeDataManager.jokes.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleCellIdentifier = @"JokeCustomCell";
    JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    
    if (self.jokeDataManager.jokes.count > 0 ) {
        JokePL *joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        
        cell.uniqueIDLabel.text = [NSString stringWithFormat:@"#%@", joke.uniqueID];
        
        cell.titleLabel.text = [NSString stringWithFormat: @"%@", joke.title];
        cell.scoreLabel.text = [NSString stringWithFormat: @"Score: %@", [self quickStringFromInt:joke.score]];
        cell.timeLabel.text = [self turnSecondsIntoReallyShortTimeFormatColon:joke.length];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/dd/yy"];
        cell.dateLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.creationDate]];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
    
    if (self.jokeDataManager.jokes.count == 0) {
        self.deleteBarButton.title = nil;
        [self.tableView setEditing:![self.tableView isEditing]];
    }
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"jokeCreationViewSegue"])
    {
        // Get reference to the destination view controller
        CreateViewController *cvc = (CreateViewController*) [segue destinationViewController];
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
    
    else if ([[segue identifier] isEqualToString:@"setCreationViewSegue"])
    {
        // Get reference to the destination view controller
        SetCreateViewController *scvc = (SetCreateViewController*)[segue destinationViewController];
        scvc.jokeDataManager = self.jokeDataManager;
    }
}



- (IBAction)deleteBarButtonAction:(id)sender {

    if (![self.tableView isEditing]) {
        [sender setTitle:@"Done"];
    }
    else {
        [sender setTitle:@"Delete"];
    }
    
    [self.tableView setEditing:![self.tableView isEditing]];
    
}

- (IBAction) addSetButtonAction {
    
    [self performSegueWithIdentifier:@"setCreationViewSegue" sender:self];
}

                                                                                                                                              
- (IBAction) addJokeButtonAction {
    
    [self performSegueWithIdentifier:@"jokeCreationViewSegue" sender:self];

    
}
                                                                                                                                              
                                                                                                                                              
                                                                                                                                        
                                                                                                                                              



@end
