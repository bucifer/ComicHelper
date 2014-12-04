//
//  InitialCustomViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateJokeViewController.h"
#import "SingleJokeViewController.h"
#import "Joke.h"
#import "JokeCD.h"
#import "Set.h"
#import "JokeCustomCell.h"
#import "NSObject+NSObject___TerryConvenience.h"
#import "MultiJokesSelectionController.h"

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

    
    NSArray *buttonArray = [NSArray arrayWithObjects:addSetButton, addJokeButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //we need a way to sort the jokes when you created a new joke or edited a joke
    
    [self.jokeDataManager refreshJokesCDDataWithNewFetch];
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
        Joke *joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        
        cell.uniqueIDLabel.text = [NSString stringWithFormat:@"#%@", joke.uniqueID];
        
        cell.nameLabel.text = [NSString stringWithFormat: @"%@", joke.name];
        cell.scoreLabel.text = [NSString stringWithFormat: @"Score: %@", [self quickStringFromInt:joke.score]];
        cell.timeLabel.text = [self turnSecondsIntoReallyShortTimeFormatColon:joke.length];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/dd/yy"];
        cell.dateLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.writeDate]];
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
        
        //Delete from Data Source
        [self.jokeDataManager deleteJoke:indexPath];
        
        //Delete from visually
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (self.jokeDataManager.jokes.count == 0) {
        //Just an aesthetic gimmick. I didn't want the delete button to show up when a user has no jokes
        self.deleteBarButton.title = nil;
        [self.tableView setEditing:![self.tableView isEditing]];
    }
}







#pragma mark - Navigation and IBActions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"jokeCreationViewSegue"])
    {
        // Get reference to the destination view controller
        CreateJokeViewController *cvc = (CreateJokeViewController*) [segue destinationViewController];
        cvc.jokeDataManager = self.jokeDataManager;
    }
    else if ([[segue identifier] isEqualToString:@"singleView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SingleJokeViewController *sjvc = [segue destinationViewController];
        Joke *selectedJoke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
        sjvc.joke  = selectedJoke;
        sjvc.title = selectedJoke.name;
        sjvc.jokeDataManager = self.jokeDataManager;
    }
    
    else if ([[segue identifier] isEqualToString:@"setCreationViewSegue"])
    {
        // Get reference to the destination view controller
        MultiJokesSelectionController *scvc = (MultiJokesSelectionController*)[segue destinationViewController];
        scvc.jokeDataManager = self.jokeDataManager;
    }
}



- (IBAction)deleteBarButtonAction:(id)sender {
    
    UIBarButtonItem *barButtonItemPointer = (UIBarButtonItem *) sender;
    
    if (![self.tableView isEditing]) {
        [barButtonItemPointer setTitle:@"Done"];
    }
    else {
        [barButtonItemPointer setTitle:@"Delete"];
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
