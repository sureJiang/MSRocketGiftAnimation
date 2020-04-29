//
//  MSCostlyGiftItemView.h
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCostlyGiftItemView : UIView

@property (strong, nonatomic, readonly) UIImageView *itemImageView;

@property (nonatomic,strong) UIImage *itemImage;

@property (nonatomic,strong) UIImage *itemAnimatedOverlayImage;

@property (nonatomic) CGFloat zPosition;

- (void)perform3DAnimation;

- (void)performFlashAnimation;

- (void)performRockAnimation;

@end
