//
//  UIBezierPath+NSBezierPath.h
//  GiftAnimationDemo
//
//  Created by J. on 2/23/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath(NSBezierPath)

@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat length;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) CGPoint firstPoint;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) CGPoint lastPoint;
@property (nonatomic, strong, getter=getElements) NSMutableArray* elements;

- (void) updatePathElements;
- (UIBezierPath*) bezierPathByTrimmingToLength:(float) trimLength;
- (UIBezierPath*) bezierPathByTrimmingFromLength:(float) trimLength;

@end
