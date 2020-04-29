//
//  MSCostlyGift.h
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSRoomAtmosphereView.h"

typedef NS_ENUM(NSUInteger, MSCostlyGiftComboStyle) {
    MSCostlyGiftComboStyleGolden,
    MSCostlyGiftComboStyleWhite,
    MSCostlyGiftComboStyleRed
};

FOUNDATION_EXPORT NSDictionary * MSCostlyGiftComboTextAttributesForComboStyle(MSCostlyGiftComboStyle style);

@interface MSCostlyGiftAnimationConfiguration : NSObject

@property (nonatomic) BOOL dimmingBackground;

@property (nonatomic) NSTimeInterval trayDuration;

@property (nonatomic,strong) UIImage *itemImage;
@property (nonatomic,strong) UIImage *itemAnimatedOverlayImage;

@property (nonatomic,strong) UIImage *cardImage;
@property (nonatomic,strong) UIImage *cardBreathingBackgroundImage;

@property (nonatomic,strong) UIImage *trayBackgroundImage;
@property (nonatomic,strong) UIImage *trayBreathingBackgroundImage;

@property (nonatomic,strong) UIImage *twinkleEffectImage;

@property (nonatomic) BOOL cardAnimationDisabled;
@property (nonatomic) NSTimeInterval cardDisplayDuration;

@property (nonatomic) BOOL itemRocksOnTray;

@property (nonatomic) BOOL cardHasHaloBackground;

@property (nonatomic,copy) NSURL *soundEffectURL;

@property (nonatomic) MSCostlyGiftComboStyle comboStyle;

@property (nonatomic) BOOL trayHasLightEffect;

@property (nonatomic) CGFloat cardOffsetY;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *iconBorderImage;
@property (nonatomic, strong) NSArray <UIImage *> *trayImages;
@property (nonatomic, strong) NSString *lottieName;

+ (instancetype)rocketAnimationConfiguration;
+ (instancetype)shipAnimationConfiguration;
+ (instancetype)carAnimationConfiguration;
+ (instancetype)newYearAnimationConfiguration;

- (void)setupCarTrayImages;
- (void)setupShipTrayImages;
- (void)setupRocketTrayImages;

@end


typedef NS_ENUM(NSUInteger, MSCostlyGiftSpecialAnimationType) {
    MSCostlyGiftSpecialAnimationTypeNone,
    MSCostlyGiftSpecialAnimationTypeRocket
};

@protocol MSCostlyGift <NSObject>

@property (nonatomic,copy,readonly) NSString *receiverID;
@property (nonatomic,copy,readonly) NSString *senderID;
@property (nonatomic,copy,readonly) NSString *productID;
@property (nonatomic,assign,readonly) BOOL isHasPendingCombo;

@property (nonatomic,readonly) BOOL isLowCostGift;

@property (nonatomic,readonly) NSInteger cost;

@property (nonatomic,readonly) BOOL senderIsCurrentUser;

@property (nonatomic,readonly) MSCostlyGiftAnimationConfiguration *animationConfiguration;
@property (nonatomic,readonly) MSCostlyGiftSpecialAnimationType specialAnimationType;

@property (nonatomic,copy,readonly) NSString *senderName;
@property (nonatomic,copy,readonly) NSString *detailText;

@property (nonatomic,readonly) NSInteger comboCount;
@property (nonatomic,readonly) BOOL comboHasSpecialEffect;
@property (nonatomic,readonly) MSRoomAtmosphereType ambientEffectLevel;

@property (nonatomic,copy,readonly) void (^avatarImageViewConfigurator)(UIImageView *avatarImageView);
@property (nonatomic,copy,readonly) void (^itemImageViewConfigurator)(UIImageView *itemImageView);

@end


@protocol MSGiftTrayView <NSObject>

- (void)showComboWithCount:(NSInteger)comboCount style:(MSCostlyGiftComboStyle)style;
- (void)performComboSpecialEffectAnimation;

- (void)performLightEffectAnimationWithAnimationImages:(NSArray <UIImage *> *)images;

@end
