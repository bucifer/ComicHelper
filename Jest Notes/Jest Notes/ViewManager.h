//
//  ViewManager.h
//  Jest Notes
//
//  Created by Terry Bu on 11/21/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewManager : NSObject


- (UIColor*)colorWithHexString:(NSString*)hex;
- (UIButton *) createCustomCheckmarkAccessoryViewWithImage;


@end
