//
//  MSCostlyGiftRocketAnimationView.m
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import "MSCostlyGiftRocketAnimationView.h"
#import "MSCostlyGiftTray.h"
#import "MSCostlyGiftRocketView.h"
#import <Lottie/Lottie.h>

#if !__has_feature(objc_arc)
#error MSCostlyGiftRocketAnimationView must be built with ARC.
#endif

@interface MSCostlyGiftRocketAnimationView ()
<CAAnimationDelegate>

@property (nonatomic,weak) UIView *trayView;
@property (nonatomic,weak) CAEmitterLayer *fireworksEmitter;
@property (nonatomic,strong) LOTAnimationView *rainView;
@property (nonatomic,strong) LOTAnimationView *whiteCircleView;
@property (nonatomic,strong) UIImageView *purpleImageView;
@property (nonatomic,strong) LOTAnimationView *passThroughView;
@property (nonatomic,strong) UIImageView *rocketRunwayImageView;
@property (nonatomic, strong) MSCostlyGiftRocketView *itemView;
@property (strong, nonatomic) LOTAnimationView *backAnimationView;

@end

@implementation MSCostlyGiftRocketAnimationView

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
    _backAnimationView = [LOTAnimationView animationNamed:@"border"];
    _backAnimationView.frame = self.bounds;
    _backAnimationView.userInteractionEnabled = NO;
    [self addSubview:_backAnimationView];
    [_backAnimationView play];
    
    [self setupRainView];
    
    self.whiteCircleView = [LOTAnimationView animationNamed:@"wave2_both_1334"];
    self.whiteCircleView.contentMode = UIViewContentModeScaleAspectFit;
    self.whiteCircleView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.purpleImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.purpleImageView.image = [UIImage animatedImageNamed:@"ml_wave3_bake 2_" duration:0.28];
    self.purpleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.purpleImageView.hidden = YES;
    
    self.passThroughView = [LOTAnimationView animationNamed:@"passThrough_ring"];
    self.passThroughView.contentMode = UIViewContentModeScaleAspectFit;
    self.passThroughView.frame = CGRectMake(0, 30, self.bounds.size.width, self.bounds.size.height);
    self.passThroughView.loopAnimation = YES;
    
    [self addSubview:self.whiteCircleView];
    [self addSubview:self.purpleImageView];
    [self addSubview:self.passThroughView];
    
    self.rocketRunwayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ml_ani_rocket_tray"]];
    self.rocketRunwayImageView.frame = CGRectMake(0, 0, 78, CGRectGetHeight(self.bounds));
    self.rocketRunwayImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height/2);
    self.rocketRunwayImageView.hidden = YES;
    [self addSubview:self.rocketRunwayImageView];
}

- (void)performAnimationForGift:(id<MSCostlyGift>)gift trayView:(MSCostlyGiftTray *)trayView completion:(void (^)(MSCostlyGiftItemView *))completion {
    self.trayView = trayView;
    
    MSCostlyGiftRocketView *itemView = [[UINib nibWithNibName:NSStringFromClass(MSCostlyGiftRocketView.class) bundle:[NSBundle bundleForClass:MSCostlyGiftRocketView.class]] instantiateWithOwner:nil options:nil].firstObject;
    itemView.frame = CGRectMake((CGRectGetWidth(self.bounds) - itemView.frame.size.width)/2.0, CGRectGetHeight(self.bounds) - 51, itemView.frame.size.width, itemView.frame.size.height);
    itemView.userInteractionEnabled = NO;
    itemView.itemImage = [UIImage imageNamed:@"live_ani_gift_rocket_icon"];
    itemView.itemAnimatedOverlayImage = gift.animationConfiguration.itemAnimatedOverlayImage;
    self.itemView = itemView;
    [self addSubview:itemView];
    
    [itemView addSmokeEffect];
    [itemView performRockAnimation];
    [self.whiteCircleView play];

    CGFloat finalY = itemView.layer.position.y - 0.7*[UIScreen mainScreen].bounds.size.height;
    CGFloat fromValue = itemView.layer.position.y;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    pathAnimation.delegate = self;
    pathAnimation.fromValue = @(fromValue);
    pathAnimation.byValue = @(-0.7*[UIScreen mainScreen].bounds.size.height);
    pathAnimation.duration = 5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :0.98 :0 :0.88];
    [itemView.layer addAnimation:pathAnimation forKey:@"rocktPathAnimation"];
    self.itemView.layer.position = CGPointMake(self.itemView.layer.position.x, finalY);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.passThroughView play];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.passThroughView.alpha = 0.;
            [self.passThroughView pause];
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.whiteCircleView.hidden = YES;
            [self.whiteCircleView pause];
            self.purpleImageView.hidden = NO;
            [self.purpleImageView startAnimating];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            itemView.roketAlphaStartValue = 0.5;
            itemView.roketAlphaEndValue = 1.;
            [itemView performRocketHeaderAnimation];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            itemView.vibrationX = 6;
            self.purpleImageView.hidden = YES;
            [self.purpleImageView stopAnimating];
            [self startStarAnimation];
            self.rocketRunwayImageView.hidden = NO;
            
            [UIView animateWithDuration:1
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:5
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 itemView.center = CGPointMake(itemView.center.x, - CGRectGetHeight(itemView.bounds));
                                 
                             } completion:^(BOOL finished) {
                                 if (completion) {
                                     completion(nil);
                                     [itemView removeFromSuperview];
                                 }
                             }];
            
            [UIView animateWithDuration:0.9 delay:0.1
                                options:0 animations:^{
                                    self.rocketRunwayImageView.alpha = 0.3;
                                    self.rocketRunwayImageView.transform = CGAffineTransformMakeScale(0.01, 1.0);
                                } completion:^(BOOL finished) {
                                    
                                }];
        });
    });
}

- (void)startEmitterAnimation:(CAEmitterLayer *)emitterLayer
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [emitterLayer setValue:@(0) forKeyPath:@"emitterCells.explosionCell.birthRate"];
    [CATransaction commit];
}

- (CAEmitterLayer *)setupEmitterWithPostion:(CGPoint)position
{
    CGPoint boomCenter = position;
    CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name = @"explosionCell";
    explosionCell.birthRate = 0;
    explosionCell.lifetime = 6;
    explosionCell.alphaSpeed     = -0.6;
    explosionCell.alphaRange     = 0.1;
    explosionCell.velocity       = 0;
    explosionCell.velocityRange  = 0;
    explosionCell.scale          = 0.1;
    explosionCell.scaleRange     = 0.5;
    explosionCell.contents       = (id)[UIImage imageNamed:@"live_ani_gift_rocket_star"].CGImage;
    explosionCell.spin = 1.5;
    explosionCell.spinRange = 1.0;
    explosionCell.yAcceleration = 150;
    
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    fireworksEmitter.emitterShape  = kCAEmitterLayerCircle;
    fireworksEmitter.emitterMode   = kCAEmitterLayerOutline;
    fireworksEmitter.emitterSize   = CGSizeMake(1, 1);
    fireworksEmitter.emitterCells  = @[explosionCell];
    fireworksEmitter.renderMode    = kCAEmitterLayerBackToFront;
    fireworksEmitter.position      = boomCenter;
    
    return fireworksEmitter;
}

- (void)startStarAnimation
{
    for (int i = 0; i < 3; i ++) {
        CAEmitterLayer *emitterLayer = [self setupEmitterWithPostion:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) / 4 * (i + 1))];
        [self.layer addSublayer:emitterLayer];
        
        
        [emitterLayer setValue:@(200) forKeyPath:@"emitterCells.explosionCell.birthRate"];
        [emitterLayer setValue:@(600) forKeyPath:@"emitterCells.explosionCell.velocity"];
        [emitterLayer setValue:@(400) forKeyPath:@"emitterCells.explosionCell.velocityRange"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * (i + 1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startEmitterAnimation:emitterLayer];
        });
    }
}

- (void)setupRainView
{
    _rainView = [LOTAnimationView animationNamed:@"speedLine"];
    _rainView.frame = self.bounds;
    _rainView.loopAnimation = YES;
    _rainView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_rainView];
    [_rainView play];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.itemView.vibrationX = 4;
    self.itemView.roketAlphaStartValue = 0.1;
    self.itemView.roketAlphaEndValue = 0.2;
    [self.itemView performRocketHeaderAnimation];
    [UIView animateWithDuration:3
                     animations:^{
                         self.itemView.layer.position = CGPointMake(self.itemView.layer.position.x, [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(self.itemView.bounds)/2.0);
                     }];
}

@end
