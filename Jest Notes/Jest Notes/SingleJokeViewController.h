//
//  SingleJokeViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokePL.h"
#import "JokeDataManager.h"
#import "JokeCD.h"


@interface SingleJokeViewController : UIViewController


@property (nonatomic, strong) JokePL *joke;
@property (nonatomic, strong) JokeDataManager *jokeDataManager;

@property (strong, nonatomic) IBOutlet UILabel *jokeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeIDLabel;


@end
