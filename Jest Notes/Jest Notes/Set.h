//
//  Set.h
//  Jest Notes
//
//  Created by Terry Bu on 11/7/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Set : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic, strong) NSDate *createDate;
@property int totalLength;
@property (nonatomic, strong) NSNumber *uniqueID;
@property (strong, nonatomic) NSMutableArray *jokes;

@end
