//
//  MSCostlyGiftRocketView.h
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCostlyGiftRocketView : UIView

@property (weak, nonatomic, readonly) UIImageView *itemImageView;

@property (nonatomic,strong) UIImage *itemImage;

@property (nonatomic,strong) UIImage *itemAnimatedOverlayImage;
@property (nonatomic) CGFloat zPosition;
@property (nonatomic) NSInteger vibrationX;
@property (nonatomic) float roketAlphaStartValue;
@property (nonatomic) float roketAlphaEndValue;

- (void)perform3DAnimation;
- (void)performFlashAnimation;
- (void)performRockAnimation;
- (void)addSmokeEffect;
- (void)performRocketHeaderAnimation;
- (void)perfromBoomWaveAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

@end
