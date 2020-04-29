//
//  MSCostlyGiftAnimationView.h
//  GiftAnimationDemo
//
//  Created by J.on 2/30/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCostlyGift.h"

@class MSCostlyGiftTray,MSCostlyGiftItemView;

@protocol MSCostlyGiftAnimationView <NSObject>

- (void)performAnimationForGift:(id<MSCostlyGift>)gift trayView:(MSCostlyGiftTray *)trayView completion:(void (^)(MSCostlyGiftItemView *itemView))completion;

@end

@interface MSCostlyGiftAnimationView : UIView <MSCostlyGiftAnimationView>


@end
