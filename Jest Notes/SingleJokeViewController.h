//
//  SingleJokeViewController.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/30/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Joke.h"
#import "CoreDataManager.h"
#import "JokeCD.h"


@class CoreDataManager;


@interface SingleJokeViewController : UIViewController


@property (nonatomic, strong) Joke *joke;
@property (nonatomic, strong) CoreDataManager *coreDataManager;

@property (strong, nonatomic) IBOutlet UILabel *jokeLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *jokeDateLabel;
@property (strong, nonatomic) IBOutlet UITextView *jokeBodyTextView;

@property (strong, nonatomic) IBOutlet UILabel *jokeIDLabel;

@end
