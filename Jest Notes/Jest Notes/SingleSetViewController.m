//
//  SingleSetViewController.m
//  Jest Notes
//
//  Created by Aditya Narayan on 11/22/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "SingleSetViewController.h"
#import "Joke.h"
#import "SetToJokeDetailViewController.h"

@interface SingleSetViewController ()

@end

@implementation SingleSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.jokeDataManager refreshSetsCDDataWithNewFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedSet.jokes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]; //this might crash - watch out
    }
    
    Joke *selectedJoke = [self.selectedSet.jokes objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"#%li. %@", indexPath.row + 1, selectedJoke.name];

    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 30.0 ];
    cell.textLabel.font = myFont;
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
        //do nothing
}



#pragma mark Reordering rows


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *jokesArray = self.selectedSet.jokes;
    [jokesArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    //Core Data --> SetCDs --> Each has a Jokes property of NSOrderedSet
    //When you convert at launch, SetCD becomes a Set with a Jokes property of NSMutableArray
    
    SetCD* setCD = [self.jokeDataManager getCorrespondingSetCDFromSetPL:self.selectedSet];
    NSMutableOrderedSet *mutableSet = [setCD.jokes mutableCopy];
    [mutableSet exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    setCD.jokes = [NSOrderedSet orderedSetWithArray:[mutableSet array]];
    
    [self.jokeDataManager saveChangesInContextCoreData];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //to get rid of the red delete button
    return UITableViewCellEditingStyleNone;
}

//this helps to remove unnecesary padding on the left that happens from above editingStyle set to None and delete button going away
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"JokeDetailSegue"]) {
        SetToJokeDetailViewController *stjdvc = (SetToJokeDetailViewController*) segue.destinationViewController;
        stjdvc.joke = [self.selectedSet.jokes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    
}


- (IBAction)editButton:(UIBarButtonItem *)sender {

    if (![self.tableView isEditing]) {
        [sender setTitle:@"Done"];
    }
    else {
        [sender setTitle:@"Reorder"];
    }
    
    [self.tableView setEditing:![self.tableView isEditing]];
}


@end
