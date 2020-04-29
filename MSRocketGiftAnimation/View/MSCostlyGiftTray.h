//
//  MSCostlyGiftTray.h
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCostlyGift.h"

@interface MSCostlyGiftTray : UIView <MSGiftTrayView>

@property (strong, nonatomic, readonly) UIView *giftIconView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *detailLabel;
@property (strong, nonatomic, readonly) UIImageView *avatarImageView;

@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,strong) UIImage *breathingBackgroundImage;

@property (nonatomic,copy) void (^avatarImageViewTappedHandler)(void);

- (void)performHighlightAnimation;

- (void)performBreathingAnimation;

@end
