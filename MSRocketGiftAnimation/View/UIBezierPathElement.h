//
//  UIBezierPathElement.h
//  GiftAnimationDemo
//
//  Created by J. on 2/28/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#endif

@interface UIBezierPathElement : NSObject

@property (nonatomic, assign) CGPathElementType type;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGPoint ctrlPoint1;
@property (nonatomic, assign) CGPoint ctrlPoint2;

+ (instancetype) elementWithCGPathElement:(const CGPathElement*) element;

- (instancetype) initWithCGPathElement:(const CGPathElement*) element;
- (CGFloat) length:(CGPoint) prevPoint;

@end
