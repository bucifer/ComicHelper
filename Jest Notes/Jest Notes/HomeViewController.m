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

@interface HomeViewController ()

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"joke data manager's moc in hvc: %@", self.jokeDataManager.managedObjectContext.description);
    
    //Let's do initialization logic
    //If it's the first time you are running the app, we don't do anything
    //If it's not the first time you are running the app, we get everything from Core Data and turn them into presentation layer jokes
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:@"notFirstLaunch"] == false)
    {
        NSLog(@"this is first time you are running the app - Do nothing");
        
        //after first launch, you set this NSDefaults key so that for consequent launches, this block never gets run
        [userDefaults setBool:YES forKey:@"notFirstLaunch"];
        [userDefaults synchronize];
    }
    else {
        //this is NOT the first launch ... Fetch from Core Data
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"JokeCD" inManagedObjectContext:self.jokeDataManager.managedObjectContext];
        [fetchRequest setEntity:entity];
        
//        // Specify criteria for filtering which objects to fetch
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
//        [fetchRequest setPredicate:predicate];
        
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
        ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

        NSError *error = nil;
        NSArray *fetchedObjects = [self.jokeDataManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"some horrible error in fetching CD: %@", error);
        }
        
        self.jokeDataManager.jokes = [self convertJokeCDsIntoJokePLs:fetchedObjects];
        [self.tableView reloadData];
    }
    
    self.createNewJokeButton.layer.cornerRadius = 5;
    self.createNewJokeButton.layer.borderWidth = 2;
    self.createNewJokeButton.layer.borderColor = [UIColor blackColor].CGColor;
}




#pragma mark data-related custom methods

- (NSMutableArray *) convertJokeCDsIntoJokePLs: (NSArray *) fetchedObjectsArrayOfCDJokes {
    
    NSMutableArray *resultArrayOfJokePLs = [[NSMutableArray alloc]init];
    
    for (int i=0; i < fetchedObjectsArrayOfCDJokes.count; i++) {
        JokeCD *oneCDJoke = fetchedObjectsArrayOfCDJokes[i];
        JokePL *newPLJoke = [[JokePL alloc]init];
        newPLJoke.title = oneCDJoke.title;
        newPLJoke.score = [oneCDJoke.score intValue];
        newPLJoke.length = [oneCDJoke.length intValue];
        newPLJoke.creationDate = oneCDJoke.creationDate;
        [resultArrayOfJokePLs addObject:newPLJoke];
    }
    
    return resultArrayOfJokePLs;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.jokeDataManager.jokes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    JokePL *joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@ (%d)", joke.title, joke.score];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [dateFormatter stringFromDate:joke.creationDate]];

    
    return cell;
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





@end
