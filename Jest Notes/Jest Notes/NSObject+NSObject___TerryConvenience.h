//
//  NSObject+NSObject___TerryConvenience.h
//  ComicsHelperApp
//
//  Created by Terry Bu on 10/31/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject___TerryConvenience)

- (NSString *) quickStringFromInt: (int) someInt;

- (NSString *) turnSecondsIntegerIntoMinuteAndSecondsFormat: (int) seconds;
- (NSString *) turnSecondsIntoReallyShortTimeFormatColon: (int) seconds;

@end
