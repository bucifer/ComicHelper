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
#import "JokeCustomCell.h"
#import "NSObject+NSObject___TerryConvenience.h"

@interface HomeViewController ()

@end



@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.jokeDataManager appInitializationLogic];
    
    self.createNewJokeButton.layer.cornerRadius = 5;
    self.createNewJokeButton.layer.borderWidth = 2;
    self.createNewJokeButton.layer.borderColor = [UIColor blackColor].CGColor;
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
    
    static NSString *simpleCellIdentifier = @"JokeCustomCell";
    JokeCustomCell *cell = (JokeCustomCell*) [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    
    JokePL *joke = [self.jokeDataManager.jokes objectAtIndex:indexPath.row];
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

- (NSString *) turnSecondsIntoReallyShortTimeFormatColon: (int) seconds {
    
    int minutes = seconds / 60;
    int secondsLeftover = seconds % 60;
    NSString* secondsString;
    
    if (secondsLeftover < 10) {
        secondsString = [NSString stringWithFormat:@"0%d", secondsLeftover];
    }
    else {
        secondsString = [NSString stringWithFormat:@"%d", secondsLeftover];
    }
    
    
    if (minutes == 0) {
        return [NSString stringWithFormat:@"0:%@", secondsString];
    }
    else if (minutes == 1) {
        return [NSString stringWithFormat:@"1:%@", secondsString];
    }
    
    return [NSString stringWithFormat:@"%d:%@", minutes, secondsString];
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
