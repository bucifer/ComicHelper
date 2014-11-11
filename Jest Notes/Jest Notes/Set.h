//
//  Set.h
//  Jest Notes
//
//  Created by Aditya Narayan on 11/7/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Set : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *jokes;
@property (nonatomic, strong) NSDate *creationDate;
@property int totalLength;

@end
