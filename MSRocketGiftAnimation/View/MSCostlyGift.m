//
//  MSCostlyGift.m
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#if !__has_feature(objc_arc)
#error MSCostlyGiftAnimationConfiguration must be built with ARC.
#endif

#import "MSCostlyGift.h"

NSDictionary * MSCostlyGiftComboTextAttributesForComboStyle(MSCostlyGiftComboStyle style) {
    switch (style) {
        case MSCostlyGiftComboStyleGolden: {
            return @{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:236/255.0 blue:19/255.0 alpha:1.0],
                     NSStrokeWidthAttributeName: @(-4),
                     NSStrokeColorAttributeName: [UIColor colorWithRed:231/255.0 green:138/255.0 blue:28/255.0 alpha:1.0],
                     NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                     NSKernAttributeName: @(2)};
        } break;
        case MSCostlyGiftComboStyleWhite: {
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSStrokeWidthAttributeName: @(-4),
                     NSStrokeColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5],
                     NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                     NSKernAttributeName: @(2)};
        } break;
        case MSCostlyGiftComboStyleRed: {
            return @{NSForegroundColorAttributeName: [UIColor colorWithRed:232.f/255.0 green:66.f/255.0 blue:57.f/255.0 alpha:1],
                     NSStrokeWidthAttributeName: @(-4),
                     NSStrokeColorAttributeName: [UIColor colorWithRed:255/255.0 green:239/255.0 blue:17/255.0 alpha:0.5],
                     NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                     NSKernAttributeName: @(2)};
        } break;
        default: {
            return @{};
        } break;
    }
}

@implementation MSCostlyGiftAnimationConfiguration

+ (instancetype)rocketAnimationConfiguration {
    static MSCostlyGiftAnimationConfiguration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[MSCostlyGiftAnimationConfiguration alloc] init];
        configuration.trayDuration = 2.0;
        configuration.itemImage = [UIImage imageNamed:@"live_ani_gift_rocket"];
        configuration.itemAnimatedOverlayImage = [UIImage animatedImageNamed:@"ml_jet_" duration:0.17];
        configuration.trayBackgroundImage = [UIImage imageNamed:@"live_ani_gift_board_3"];
        configuration.trayBreathingBackgroundImage = [UIImage imageNamed:@"live_ani_gift_board_red"];
        configuration.twinkleEffectImage = [UIImage imageNamed:@"live_ani_gift_star_red"];
        configuration.soundEffectURL = [[NSBundle mainBundle] URLForResource:@"ml_rocket_effect" withExtension:@"caf"];
        configuration.cardDisplayDuration = 4.0;
        configuration.itemRocksOnTray = YES;
        configuration.dimmingBackground = YES;
        configuration.comboStyle = MSCostlyGiftComboStyleGolden;
        configuration.trayHasLightEffect = YES;
    });
    return configuration.copy;
}

+ (instancetype)shipAnimationConfiguration {
    static MSCostlyGiftAnimationConfiguration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[MSCostlyGiftAnimationConfiguration alloc] init];
        configuration.trayDuration = 2.0;
        configuration.itemImage = [UIImage imageNamed:@"live_ani_gift_yacht"];
        configuration.itemAnimatedOverlayImage = nil;
        configuration.trayBackgroundImage = [UIImage imageNamed:@"live_ani_gift_board_2"];
        configuration.trayBreathingBackgroundImage = [UIImage imageNamed:@"live_ani_gift_board_blue"];
        configuration.twinkleEffectImage = [UIImage imageNamed:@"live_ani_gift_star_blue"];
        configuration.soundEffectURL = [[NSBundle mainBundle] URLForResource:@"ml_costly_gift_effect" withExtension:@"caf"];
        configuration.cardDisplayDuration = 4.0;
        configuration.itemRocksOnTray = NO;
        configuration.comboStyle = MSCostlyGiftComboStyleGolden;
        configuration.trayHasLightEffect = YES;
        configuration.lottieName = @"panel_Lv2";
    });
    return configuration.copy;
}

+ (instancetype)carAnimationConfiguration {
    static MSCostlyGiftAnimationConfiguration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[MSCostlyGiftAnimationConfiguration alloc] init];
        configuration.trayDuration = 2.0;
        configuration.itemImage = [UIImage imageNamed:@"live_ani_gift_car"];
        configuration.itemAnimatedOverlayImage = nil;
        configuration.trayBackgroundImage = [UIImage imageNamed:@"live_ani_gift_board_1"];
        configuration.trayBreathingBackgroundImage = nil;
        configuration.twinkleEffectImage = nil;
        configuration.soundEffectURL = nil;
        configuration.cardDisplayDuration = 3.0;
        configuration.itemRocksOnTray = NO;
        configuration.comboStyle = MSCostlyGiftComboStyleGolden;
        configuration.trayHasLightEffect = YES;
        configuration.lottieName = @"panel_Lv1";
    });
    return configuration.copy;
}

+ (instancetype)newYearAnimationConfiguration {
    static MSCostlyGiftAnimationConfiguration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[MSCostlyGiftAnimationConfiguration alloc] init];
        configuration.trayDuration = 2.0;
        configuration.itemImage = [UIImage imageNamed:@"live_ani_gift_car"];
        configuration.itemAnimatedOverlayImage = nil;
        configuration.cardImage = [UIImage imageNamed:@"live_ani_gift_back_year"];
        configuration.trayBackgroundImage = [UIImage imageNamed:@"live_ani_gift_board_year"];
        configuration.trayBreathingBackgroundImage = nil;
        configuration.twinkleEffectImage = nil;
        configuration.soundEffectURL = nil;
        configuration.cardDisplayDuration = 3.0;
        configuration.itemRocksOnTray = NO;
        configuration.cardBreathingBackgroundImage = [UIImage imageNamed:@"live_ani_gift_back_1_b"];
        configuration.comboStyle = MSCostlyGiftComboStyleRed;
        configuration.trayHasLightEffect = YES;
        configuration.textColor = [UIColor colorWithRed:252 green:233 blue:122 alpha:1.0];
        configuration.iconBorderImage = @"live_ani_gift_icon_border";
    });
    return configuration.copy;
}

- (void)setupCarTrayImages
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 21; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ml_Lable_light_Lv1_%d", i]];
        [images addObject:image];
    }
    self.trayImages = images.copy;
}

- (void)setupShipTrayImages
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 21; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ml_Lable_light_Lv2_%d", i]];
        [images addObject:image];
    }
    self.trayImages = images.copy;
}

- (void)setupRocketTrayImages
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 46; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ml_Lable_light_Lv3_%d", i]];
        [images addObject:image];
    }
    self.trayImages = images.copy;
}

@end
