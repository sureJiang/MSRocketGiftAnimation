//
//  MSRoomAtmosphereView.m
//  GiftAnimationDemo
//
//  Created by J.on 2/28/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import "MSRoomAtmosphereView.h"
#import "UIBezierPath+NSBezierPath.h"

#if !__has_feature(objc_arc)
#error MSRoomAtmosphereView must be built with ARC.
#endif

static MSRoomAtmosphereView * __weak currentAtmosphereView;

static NSInteger const MSRoomAtmosphereViewNumberOfLights = 64;
static CGFloat   const MSRoomAtmosphereViewLightsCornerRadius = 50;

@interface MSRoomAtmosphereView ()

@property (nonatomic,weak) UIImageView *backgroundView;

@property (nonatomic,copy) NSArray<UIView *> *lights;

@property (nonatomic,copy) UIBezierPath *lightsPath;
@property (nonatomic,assign) BOOL loop;

@end

@implementation MSRoomAtmosphereView

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectIsEmpty(frame)) {
        frame = UIScreen.mainScreen.bounds;
    }
    if (self = [super initWithFrame:frame]) {
        [self setupAtmosphereView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupAtmosphereView];
    }
    return self;
}

- (void)setupAtmosphereView {
    [currentAtmosphereView stopAnimating];
    [currentAtmosphereView removeFromSuperview];
    
    currentAtmosphereView = self;
    
    self.userInteractionEnabled = NO;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.image = [UIImage imageNamed:@"ml_room_led_overlay"];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.alpha = 0;
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    UIImage *image = [UIImage imageNamed:@"ml_room_led_light"];
    NSMutableArray *lights = [NSMutableArray array];
    for (NSInteger i = 0; i < MSRoomAtmosphereViewNumberOfLights; i += 1) {
        UIImageView *light = [[UIImageView alloc] initWithImage:image];
        light.alpha = 0;
        [self addSubview:light];
        [lights addObject:light];
    }
    self.lights = lights;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, CGRectGetWidth(self.lights.firstObject.bounds)/4.0, CGRectGetHeight(self.lights.firstObject.bounds)/4.0) cornerRadius:MSRoomAtmosphereViewLightsCornerRadius];
    self.lightsPath = path;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, CGRectGetWidth(self.lights.firstObject.bounds)/4.0, CGRectGetHeight(self.lights.firstObject.bounds)/4.0) cornerRadius:MSRoomAtmosphereViewLightsCornerRadius];
    CGFloat percent = 0;
    for (UIView *light in self.lights) {
        light.center  = [path bezierPathByTrimmingToLength:path.length * percent].lastPoint;
        percent += 1.0/MSRoomAtmosphereViewNumberOfLights;
    }
    self.lightsPath = path;
}

- (void)stopAnimating {
    for (UIView *light in self.lights) {
        [light.layer removeAllAnimations];
        light.alpha = 0;
    }
}

- (void)performFlowAnimation {
    void(^animateLightAtIndex)(NSInteger index, NSInteger i, NSInteger finishIndex) = ^(NSInteger index, NSInteger i, NSInteger finishIndex) {
        UIView *light = [self lightAtIndex:index];
        light.alpha = 0;
        [UIView animateWithDuration:0.3
                              delay:i * 0.04
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             light.alpha = 1;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [UIView animateWithDuration:0.3 delay:0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      light.alpha = 0;
                                                  } completion:^(BOOL finished) {
                                                      if (index == finishIndex && finished) {
                                                          [UIView animateWithDuration:0.3 animations:^{
                                                              self.backgroundView.alpha = 0;
                                                          }];
                                                      }
                                                  }];
                             }
                         }];
    };
    NSIndexSet *rightGroupIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, floor(self.lights.count/2.0))];
    NSIndexSet *leftGroupIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.lights.count/2, ceil(self.lights.count/2.0))];
    NSInteger __block i = 0;
    [rightGroupIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        animateLightAtIndex(idx, i, self.lights.count/2);
        i++;
    }];
    i = 0;
    [leftGroupIndexes enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        animateLightAtIndex(idx,i,self.lights.count/2);
        i++;
    }];
}

- (void)performDiamondAnimation {
    __weak __typeof(self) weakSelf = self;
    
    NSInteger numberOfSections = 4;
    NSInteger numberOfLightsInSection = self.lights.count/numberOfSections;
    NSInteger index = 0;
    for (NSInteger section = 0; section < numberOfSections; section += 1) {
        NSInteger startIndex = 0;
        if (section % 2 == 0) {
            startIndex = index + self.horizontalLightCount;
        } else {
            startIndex = index;
        }
        
        NSIndexSet *otherIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, numberOfLightsInSection - self.horizontalLightCount)];
        [otherIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *light = [self lightAtIndex:idx];
            light.alpha = 0;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 light.alpha = 1;
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [UIView animateWithDuration:0.3 delay:0
                                                         options:UIViewAnimationOptionCurveEaseInOut
                                                      animations:^{
                                                          light.alpha = 0;
                                                      } completion:^(BOOL finished) {
                                                          
                                                      }];
                                 }
                             }];
        }];
        
        NSInteger offset = 0;
        if (section % 2 == 0) {
            offset = 0;
        } else {
            offset = numberOfLightsInSection - self.horizontalLightCount;
        }
        for (NSInteger i = 0; i < floor(self.horizontalLightCount/2.0) + 1; i += 1) {
            UIView *lightA = [self lightAtIndex:index + i + offset];
            UIView *lightB = [self lightAtIndex:index + self.horizontalLightCount - i + offset];
            
            lightA.alpha = 0;
            [UIView animateWithDuration:0.3
                                  delay:i * 0.12
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 lightA.alpha = 1;
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [UIView animateWithDuration:0.3 delay:0
                                                         options:UIViewAnimationOptionCurveEaseInOut
                                                      animations:^{
                                                          lightA.alpha = 0;
                                                      } completion:^(BOOL finished) {
                                                          
                                                      }];
                                 }
                             }];
            
            lightB.alpha = 0;
            [UIView animateWithDuration:0.3
                                  delay:i * 0.12
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 lightB.alpha = 1;
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [UIView animateWithDuration:0.3 delay:0
                                                         options:UIViewAnimationOptionCurveEaseInOut
                                                      animations:^{
                                                          lightB.alpha = 0;
                                                      } completion:^(BOOL finished) {
                                                          if (i == floor(weakSelf.horizontalLightCount/2.0) && finished) {
                                                              if (weakSelf.loop) {
                                                                  [weakSelf performDiamondAnimation];
                                                              }
                                                          }
                                                      }];
                                 }
                             }];
        }
        index += numberOfLightsInSection;
    }
}

- (void)startAnimatingWithType:(MSRoomAtmosphereType)type withLoop:(BOOL)loop {
    //[self stopAnimating];
    self.loop = loop;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.backgroundView.alpha = 1;
                     }];
    if (type == MSRoomAtmosphereTypeFlow) {
        [self performFlowAnimation];
    } else if (type > MSRoomAtmosphereTypeFlow) {
        [self performDiamondAnimation];
    }
}

- (NSInteger)horizontalLightCount {
    return (CGRectGetWidth(self.lightsPath.bounds)/2.0 - self.lightsPath.firstPoint.x + 2 * M_PI * MSRoomAtmosphereViewLightsCornerRadius / 4.0) * 2 / self.lightsPath.length * MSRoomAtmosphereViewNumberOfLights;
}

- (UIView *)lightAtIndex:(NSInteger)index {
      NSInteger firstLightIndex = ceil((CGRectGetWidth(self.lightsPath.bounds)/2.0 - self.lightsPath.firstPoint.x)/self.lightsPath.length * MSRoomAtmosphereViewNumberOfLights);
    return self.lights[(index + firstLightIndex)%self.lights.count];
}

@end
