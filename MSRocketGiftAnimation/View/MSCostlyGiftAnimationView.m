//
//  MSCostlyGiftAnimationView.m
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import "MSCostlyGiftAnimationView.h"
#import "MSCostlyGiftItemView.h"
#import "MSCostlyGiftTray.h"
#import <lottie-ios/Lottie/Lottie.h>

#if !__has_feature(objc_arc)
#error MSCostlyGiftAnimationView must be built with ARC.
#endif

@interface MSCostlyGiftAnimationView ()

@property (nonatomic,weak) UIView *dimmingView;
@property (nonatomic,strong) LOTAnimationView *lottieAnimationView;
@property (nonatomic,weak) UIView *trayView;

@end

@implementation MSCostlyGiftAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAnimationView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupAnimationView];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = [super pointInside:point withEvent:event];
    CGPoint pointToTrayView = [self convertPoint:point toView:self.trayView];
    if(pointInside && [self.trayView pointInside:pointToTrayView withEvent:event]) {
        return YES;
    }
    return NO;
}

- (void)setupAnimationView {    
    UIView *dimmingView = [[UIView alloc] initWithFrame:self.bounds];
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    dimmingView.alpha = 0;
    [self addSubview:dimmingView];
    self.dimmingView = dimmingView;
}

- (void)performAnimationForGift:(id<MSCostlyGift>)gift trayView:(MSCostlyGiftTray *)trayView completion:(void (^)(MSCostlyGiftItemView *))completion {
    self.trayView = trayView;
    
    CGRect giftIconViewFrame = [trayView.giftIconView convertRect:trayView.giftIconView.bounds toView:self];
    
    CGSize finalCardSize = CGSizeMake(375, 240);
    CGFloat initialCardPositionToBottom = 300;
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        initialCardPositionToBottom = 240;
    }
    initialCardPositionToBottom -= gift.animationConfiguration.cardOffsetY;
    
    
    MSCostlyGiftItemView *itemView = [[UINib nibWithNibName:NSStringFromClass(MSCostlyGiftItemView.class) bundle:[NSBundle bundleForClass:MSCostlyGiftItemView.class]] instantiateWithOwner:nil options:nil].firstObject;
    itemView.userInteractionEnabled = NO;
    itemView.itemImage = gift.animationConfiguration.itemImage;
    if (gift.itemImageViewConfigurator) {
        gift.itemImageViewConfigurator(itemView.itemImageView);
    }
    itemView.itemAnimatedOverlayImage = gift.animationConfiguration.itemAnimatedOverlayImage;
    [self addSubview:itemView];
    itemView.alpha = 0;
    itemView.frame = CGRectMake(0, 0, 240, 240);
    itemView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds) - initialCardPositionToBottom + finalCardSize.height / 2);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    
    CATransform3D itemViewTransform = transform;
    itemViewTransform = CATransform3DTranslate(itemViewTransform, 0, 60 + 40, 0);
    itemView.layer.transform = itemViewTransform;

    itemView.zPosition = 2000;
    
    if (gift.animationConfiguration.dimmingBackground) {
        [UIView
         animateWithDuration:0.3
         animations:^{
             self.dimmingView.alpha = 1;
         }];
    }
    
    CGFloat rotationDuration = 0.4;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animation];
    rotationAnimation.duration = rotationDuration;
    rotationAnimation.keyPath = @"transform.rotation.y";
    rotationAnimation.fromValue = @(-M_PI_2 * 3);
    rotationAnimation.toValue = @(0);
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *scaleXAnimation = [CABasicAnimation animation];
    scaleXAnimation.duration = rotationDuration;
    scaleXAnimation.keyPath = @"transform.scale.x";
    scaleXAnimation.fromValue = @(0.3);
    scaleXAnimation.toValue = @(1);
    scaleXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *scaleYAnimation = [CABasicAnimation animation];
    scaleYAnimation.duration = rotationDuration;
    scaleYAnimation.keyPath = @"transform.scale.y";
    scaleYAnimation.fromValue = @(0.3);
    scaleYAnimation.toValue = @(1);
    scaleYAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [UIView
     animateWithDuration:rotationDuration - 0.1
     delay:0.0
     options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
     animations:^{
         itemView.alpha = 1.0;
         itemView.layer.transform = transform;
         [itemView.layer addAnimation:rotationAnimation forKey:nil];
         [itemView.layer addAnimation:scaleXAnimation forKey:nil];
         [itemView.layer addAnimation:scaleYAnimation forKey:nil];
     } completion:^(BOOL finished) {
         [itemView performFlashAnimation];
     }];
    
    if (gift.animationConfiguration.lottieName) {
        _lottieAnimationView = [LOTAnimationView animationNamed:gift.animationConfiguration.lottieName];
        _lottieAnimationView.frame = self.bounds;
        _lottieAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        _lottieAnimationView.center = itemView.center;
        [self insertSubview:_lottieAnimationView atIndex:0];
        [_lottieAnimationView playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rotationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        {
            [itemView perform3DAnimation];
            [UIView
             animateWithDuration:0.1
             delay:gift.animationConfiguration.cardDisplayDuration + 0.2
             options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
             animations:^{
                 trayView.transform = CGAffineTransformMakeScale(0.7, 0.7);
             } completion:^(BOOL finished) {
                 
             }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((gift.animationConfiguration.cardDisplayDuration - 0.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CABasicAnimation *itemRotationAnimation = rotationAnimation.copy;
                itemRotationAnimation.fromValue = @(-M_PI_2 * 8);
                itemRotationAnimation.duration = 0.6;
                scaleXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                [itemView.layer addAnimation:itemRotationAnimation forKey:nil];
                [self removeLottieAnimationView];
            });
            
            [UIView
             animateWithDuration:0.25
             delay:gift.animationConfiguration.cardDisplayDuration
             options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
             animations:^{
                 self.dimmingView.alpha = 0;
                 itemView.frame = giftIconViewFrame;
             }
             completion:^(BOOL finished) {
                 if (gift.animationConfiguration.itemRocksOnTray) {
                     [itemView performRockAnimation];
                 }
                 
                 [UIView
                  animateWithDuration:0.6
                  delay:0.0
                  usingSpringWithDamping:0.3
                  initialSpringVelocity:0
                  options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                  animations:^{
                      itemView.transform = CGAffineTransformIdentity;
                      trayView.transform = CGAffineTransformIdentity;
                  }
                  completion:^(BOOL finished) {
                      if (completion) {
                          completion(itemView);
                      }
                  }];
             }];
        }
    });
}

- (void)removeLottieAnimationView
{
    [_lottieAnimationView pause];
    [_lottieAnimationView removeFromSuperview];
    _lottieAnimationView = nil;
}

@end
