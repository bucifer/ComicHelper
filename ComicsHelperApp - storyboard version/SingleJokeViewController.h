//
//  SingleJokeViewController.h
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Joke.h"
#import "JokeDataManager.h"


@interface SingleJokeViewController : UIViewController


@property (nonatomic, strong) Joke *joke;
@property (nonatomic, strong) JokeDataManager *jokeDataManager;

@property (strong, nonatomic) IBOutlet UILabel *jokeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeDateLabel;


@end