//
//  SetToJokeDetailViewController.h
//  Jest Notes
//
//  Created by Aditya Narayan on 12/4/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Joke.h"

@interface SetToJokeDetailViewController : UIViewController

@property (strong, nonatomic) Joke* joke;

@property (strong, nonatomic) IBOutlet UITextView *jokeBodyTextView;

@end
