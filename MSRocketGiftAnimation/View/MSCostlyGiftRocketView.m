//
//  MSCostlyGiftRocketView.m
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import "MSCostlyGiftRocketView.h"
//#import "UIDevice-Hardware.h"

#if !__has_feature(objc_arc)
#error MSCostlyGiftRocketView must be built with ARC.
#endif

@interface MSCostlyGiftRocketView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *overlayImageView;

@property (retain, nonatomic) IBOutlet UIView *smokeEmitterView;

@property (retain, nonatomic) IBOutlet UIImageView *rocketHeadOverlayA;

@property (nonatomic,strong) CADisplayLink *displayLink;

@property (nonatomic) BOOL performingRockAnimation;

@end

@implementation MSCostlyGiftRocketView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rocketHeadOverlayA.alpha = 0;
    self.vibrationX = 2;
}

- (void)didMoveToWindow {
    if (self.window) {
        [self.displayLink invalidate];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    } else {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (UIImageView *)itemImageView {
    return self.imageView;
}

- (void)setItemImage:(UIImage *)itemImage {
    _itemImage = itemImage;
    self.imageView.image = itemImage;
}

- (void)setItemAnimatedOverlayImage:(UIImage *)itemAnimatedOverlayImage {
    _itemAnimatedOverlayImage = itemAnimatedOverlayImage;
    self.overlayImageView.image = itemAnimatedOverlayImage;
    [self.overlayImageView startAnimating];
}

- (void)update:(id)sender {
    if (self.performingRockAnimation) {
        static NSInteger frame = 0;
        if (++frame % 3 == 0) {
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DTranslate(transform, arc4random()%self.vibrationX, arc4random()%4, 0);
            self.imageView.layer.transform = transform;
            self.overlayImageView.layer.transform = transform;
        }
    }
}

- (void)performRockAnimation {
    self.performingRockAnimation = YES;
}

- (void)setZPosition:(CGFloat)zPosition {
    _zPosition = zPosition;
    self.layer.zPosition = zPosition;
}

- (void)performFlashAnimation {
//    UIImageView *flashImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
//    flashImageView.contentMode = self.imageView.contentMode;
//    flashImageView.alpha = 0;
//    flashImageView.tintColor = [UIColor whiteColor];
//    flashImageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [self insertSubview:flashImageView aboveSubview:self.imageView];
//    [UIView animateWithDuration:0.1
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
//                     animations:^{
//                         flashImageView.alpha = 1;
//                     } completion:^(BOOL finished) {
//                         [UIView animateWithDuration:0.15
//                                               delay:0
//                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
//                                          animations:^{
//                                              flashImageView.alpha = 0;
//                                          } completion:^(BOOL finished) {
//                                              [flashImageView removeFromSuperview];
//                                          }];
//                     }];
}

- (void)perform3DAnimation {
    NSTimeInterval interval = 0.3;
    NSTimeInterval duration = 1.0;
    double angle = M_PI_4/2.0;
    __weak __typeof(self) weakSelf = self;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CATransform3D t = CATransform3DRotate(transform, angle, 0, 1, 0);
                         t = CATransform3DTranslate(t, 10, 0, 0);
                         weakSelf.layer.transform = t;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:duration * 2
                                               delay:interval
                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              CATransform3D t = CATransform3DRotate(transform, -angle, 0, 1, 0);
                                              t = CATransform3DTranslate(t, -20, 0, 0);
                                              weakSelf.layer.transform = t;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
}


- (void)addSmokeEffect {
//    if ([UIDevice currentDevice].platformType == UIDevice6PlusiPhone) {
//        return;
//    }
    
    self.smokeEmitterView.userInteractionEnabled = NO;
    self.smokeEmitterView.alpha = 0.6;
    
    CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
    explosionCell.birthRate = 40;
    explosionCell.lifetime = 3;
    explosionCell.alphaSpeed     = -1.5;
    explosionCell.velocity       = 400;
    explosionCell.velocityRange  = 0;
    explosionCell.scale          = 0.35;
    explosionCell.scaleRange     = 0;
    explosionCell.contents       = (id)[UIImage imageNamed:@"live_ani_gift_rocket_smoke"].CGImage;
    explosionCell.spin = 1.5;
    explosionCell.emissionLongitude = -4.75;
    explosionCell.emissionLatitude = 0;
    explosionCell.yAcceleration = -100.0;
    
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    fireworksEmitter.emitterShape  = kCAEmitterLayerRectangle;
    fireworksEmitter.emitterSize   = self.smokeEmitterView.bounds.size;
    fireworksEmitter.emitterCells  = @[explosionCell];
    fireworksEmitter.renderMode    = kCAEmitterLayerUnordered;
    fireworksEmitter.masksToBounds = NO;
    fireworksEmitter.position      = CGPointMake(self.smokeEmitterView.frame.size.width/2.0, self.smokeEmitterView.frame.size.height/2.0);
    
    [self.smokeEmitterView.layer addSublayer:fireworksEmitter];
}

- (void)perfromBoomWaveAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect fireFrame = self.overlayImageView.frame;
        fireFrame.size.height = [UIScreen mainScreen].bounds.size.height * 2;
        self.overlayImageView.frame = fireFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2
                              delay:duration - 0.2 - 0.5
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect fireFrame = self.overlayImageView.frame;
                             fireFrame.size.height = 2.0;
                             self.overlayImageView.frame = fireFrame;
                         } completion:^(BOOL finished) {
                             completion();
                         }];
    }];
}

- (void)performRocketHeaderAnimation
{
    self.rocketHeadOverlayA.alpha = self.roketAlphaStartValue;
    [UIView animateKeyframesWithDuration:0.2
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat
                              animations:^{
                                  self.rocketHeadOverlayA.alpha = self.roketAlphaEndValue;
                              } completion:^(BOOL finished) {
                                  
                              }];
}

@end
