//
//  MSCostlyGiftItemView.m
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import "MSCostlyGiftItemView.h"

#if !__has_feature(objc_arc)
#error MSCostlyGiftItemView must be built with ARC.
#endif

@interface MSCostlyGiftItemView ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *overlayImageView;

@property (nonatomic,strong) CADisplayLink *displayLink;

@property (nonatomic) BOOL performingRockAnimation;

@end

@implementation MSCostlyGiftItemView
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 35, 35);
        
        self.overlayImageView = [[UIImageView alloc] init];
        self.overlayImageView.frame = self.bounds;
        [self addSubview:self.overlayImageView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = self.bounds;
        [self addSubview:self.imageView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
            transform = CATransform3DTranslate(transform, arc4random()%2, arc4random()%2, 0);
            self.imageView.layer.transform = transform;
            
//            t是上一个transform3D tx，ty，tz对应x，y，z轴的平移
//            CATransform3D CATransform3DTranslate (CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz);
        }
    }
    //self.overlayImageView.alpha = fabs(sin(CFAbsoluteTimeGetCurrent() * 3.0));
    //static NSInteger frame = 0;
    //self.overlayImageView.alpha = fabs(sin(CFAbsoluteTimeGetCurrent() * 3.0));
}

- (void)performRockAnimation {
    self.performingRockAnimation = YES;
}

- (void)setZPosition:(CGFloat)zPosition {
    _zPosition = zPosition;
    self.layer.zPosition = zPosition;
}

- (void)performFlashAnimation {
    UIImageView *flashImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    flashImageView.contentMode = self.imageView.contentMode;
    flashImageView.alpha = 0;
    flashImageView.tintColor = [UIColor whiteColor];
    flashImageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self insertSubview:flashImageView aboveSubview:self.imageView];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         flashImageView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.15
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              flashImageView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [flashImageView removeFromSuperview];
                                          }];
                     }];
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


@end
