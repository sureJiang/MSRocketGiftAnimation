//
//  UIBezierPath+Util.h
//  GiftAnimationDemo
//
//  Created by J.on 2/28/16.
//  Copyright © 2016 J. All rights reserved.
//

#include <CoreGraphics/CGGeometry.h>

#if defined __cplusplus
extern "C"
{
#endif
    
    // returns the distance between two points
    CGFloat distance(const CGPoint& p1, const CGPoint& p2);
    
    void subdivideBezierAtT(const CGPoint bez[4], CGPoint bez1[4], CGPoint bez2[4], const CGFloat& t);
    
    CGFloat subdivideBezierAtLength(const CGPoint bez[4], CGPoint bez1[4], CGPoint bez2[4], const CGFloat& length, const CGFloat& acceptableError);
    
    CGFloat subdivideBezierAtLengthWithCache(const CGPoint bez[4], CGPoint bez1[4], CGPoint bez2[4], const CGFloat& length, const CGFloat& acceptableError, CGFloat* subBezierLengthCache);
    
    CGFloat lengthOfBezier(const  CGPoint bez[4], const CGFloat& acceptableError);
    
    CGPoint bezierTangentAtT(const CGPoint bez[4], const CGFloat& t);
    
    CGFloat bezierTangent(const CGFloat& t, const CGFloat& a, const CGFloat& b, const CGFloat& c, CGFloat d);
    
#if defined __cplusplus
};
#endif

