//
//  JokeParse.h
//  ParseStarterProject
//
//  Created by Aditya Narayan on 12/5/14.
//
//

#import <Parse/Parse.h>

@interface JokeParse : PFObject <PFSubclassing>


@property (retain) NSString *name;
@property (retain) NSString *bodyText;
@property (retain) NSDate *writeDate;
@property (retain) NSNumber *length;
@property (retain) NSNumber * score;

+ (NSString *)parseClassName;


@end
