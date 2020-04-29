//
//  MSRoomAtmosphereView.h
//  GiftAnimationDemo
//
//  Created by J.on 2/28/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSRoomAtmosphereType) {
    MSRoomAtmosphereTypeUndefine,
    MSRoomAtmosphereTypeFlow,
    MSRoomAtmosphereTypeDiamond
};

@interface MSRoomAtmosphereView : UIView

- (void)startAnimatingWithType:(MSRoomAtmosphereType)type withLoop:(BOOL)loop;

- (void)stopAnimating;

@end
