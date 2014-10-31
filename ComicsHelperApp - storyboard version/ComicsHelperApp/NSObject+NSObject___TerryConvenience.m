//
//  NSObject+NSObject___TerryConvenience.m
//  ComicsHelperApp
//
//  Created by Aditya Narayan on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "NSObject+NSObject___TerryConvenience.h"

@implementation NSObject (NSObject___TerryConvenience)

- (NSString *) quickStringFromInt: (int) someInt {
    return [NSString stringWithFormat: @"%d", someInt];
}

@end
