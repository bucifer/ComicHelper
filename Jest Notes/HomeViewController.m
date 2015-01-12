//
//  InitialCustomViewController.m
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

{
    UIRefreshControl *refreshControl;
}

@end



@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"current user's USERNAME: %@", [PFUser currentUser].username);
    
    [self initializeParseMagicAndFetchAll];
    [self.coreDataManager appInitializationLogic];
    
    [self setUpInterfaceAndNavButtons];
    [self setUpRefreshControlOnPullDown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //we need a way to sort the jokes when you created a new joke or edited a joke
    
    [self.coreDataManager refreshJokesCDDataWithNewFetch];
    [self.tableView reloadData];
    
    if (self.coreDataManager.jokes.count == 0)
        self.deleteBarButton.title = nil;
    else if (self.coreDataManager.jokes.count > 0)
        self.deleteBarButton.title = @"Delete";
    
    self.pageRootController.pageControlCustomView.hidden = NO;
    for (UIScrollView *view in self.pageRootController.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = YES;
        }
    }
}


- (void) setUpInterfaceAndNavButtons {
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    UIBarButtonItem *addJokeButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pen"] style:UIBarButtonItemStyleDone target:self action:@selector(addJokeButtonAction)];
    
    UIBarButtonItem *addSetButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"set"] style:UIBarButtonItemStyleDone  target:self action:@selector(addSetButtonAction)];
    
    addJokeButton.imageInsets = UIEdgeInsetsMake(0, 3, 1.5, 0);
    addSetButton.imageInsets = UIEdgeInsetsMake(0.75, 0, 0, 3);
    
    NSArray *buttonArray = [NSArray arrayWithObjects:addSetButton, addJokeButton, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
}

- (void) setUpRefreshControlOnPullDown {
    //Refresh on pull-down
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 20, 20)];
    [self.tableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    //    refreshControl.tintColor = [UIColor blueColor];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

//For the UIFReshControl's action on pull-down
-(void)refreshData
{
    //update here...
    [self.parseDataManager fetchAllParseJokesAsynchronously];
    [self.coreDataManager refreshJokesCDDataWithNewFetch];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}


- (void) initializeParseMagicAndFetchAll {
    //Parse Related
    ParseDataManager *myParseDataManager = [ParseDataManager sharedParseDataManager];
    myParseDataManager.managedObjectContext = self.coreDataManager.managedObjectContext;
    myParseDataManager.delegate = self;
    self.parseDataManager = myParseDataManager;
    [self.parseDataManager fetchAllParseJokesAsynchronously];
    [self.parseDataManager fetchAllParseSets];
}








#pragma mark Parse Data Manager delegate methods

- (void) parseDataManagerDidFinishFetchingAllParseJokes {
    NSLog(@"Parse Data Manager finished getting all parse jokes ... reporting from homeview");
    [self.coreDataManager refreshJokesCDDataWithNewFetch];
    [self.tableView reloadData];
}

- (void)parseDataManagerDidFinishSynchingCoreDataWithParse {
    NSLog(@"Parse Data Manager finished syncing all parse jokes ... reporting from homeview");
    [self.coreDataManager refreshJokesCDDataWithNewFetch];
    [self.tableView reloadData];
}

- (void) parseDataManagerDidFinishFetchingAllParseSets {
    NSLog(@"PDM did finish fetching all parse sets from server - sending notification to setsviewcontroller for sets reloading");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ParseSetsFetchDone" object:self];
    [self.coreDataManager refreshSetsCDDataWithNewFetch];
    
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
    
    static NSString *simpleCellIdentifier = @"JokeCustomCell";
    JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    
    if (self.coreDataManager.jokes.count > 0 ) {
        Joke *joke = [self.coreDataManager.jokes objectAtIndex:indexPath.row];
        joke.uniqueID = [NSNumber numberWithLong:indexPath.row+1];
        
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
        [self.coreDataManager deleteJoke:indexPath];
        
        //Delete from visually
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (self.coreDataManager.jokes.count == 0) {
        //Just an aesthetic gimmick. I didn't want the delete button to show up when a user has no jokes
        self.deleteBarButton.title = nil;
    }
}






#pragma mark - Navigation and IBActions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self hidePageControl];
    
    for (UIScrollView *view in self.pageRootController.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = NO;
        }
    }
    
    if ([[segue identifier] isEqualToString:@"jokeCreationViewSegue"])
    {
        // Get reference to the destination view controller
        CreateJokeViewController *cvc = (CreateJokeViewController*) [segue destinationViewController];
        cvc.coreDataManager = self.coreDataManager;
    }
    else if ([[segue identifier] isEqualToString:@"singleView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SingleJokeViewController *sjvc = [segue destinationViewController];
        Joke *selectedJoke = [self.coreDataManager.jokes objectAtIndex:indexPath.row];
        sjvc.joke  = selectedJoke;
        sjvc.title = selectedJoke.name;
        sjvc.coreDataManager = self.coreDataManager;
    }
    
    else if ([[segue identifier] isEqualToString:@"setCreationViewSegue"])
    {
        // Get reference to the destination view controller
        MultiJokesSelectionController *scvc = (MultiJokesSelectionController*)[segue destinationViewController];
        scvc.coreDataManager = self.coreDataManager;
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


- (void) hidePageControl {
    self.pageRootController.pageControlCustomView.hidden = YES;
}

                                                                                                                                              

@end
