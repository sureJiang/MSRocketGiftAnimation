//
//  UIBezierPath+NSBezierPath.m
//  GiftAnimationDemo
//
//  Created by J. on 2/23/16.
//  Copyright © 2016 jzj.demo. All rights reserved.
//

#import <objc/runtime.h>
#import "UIBezierPath+NSBezierPath.h"
#import "UIBezierPath+Util.h"
#import "UIBezierPathElement.h"

static CGFloat CGPointDistance(CGPoint p0, CGPoint p1)
{
    //    CGFloat dx = p1.x - p2.x;
    //    CGFloat dy = p1.y - p2.y;
    //    CGFloat dist = sqrt(pow(dx, 2) + pow(dy, 2));
    //    return dist;
    return hypotf(p1.x - p0.x, p1.y - p0.y);
}


static char PATH_ELEMENTS;

static CGFloat kDefaultTrimEpsilon = 0.5;

@implementation UIBezierPath(NSBezierPath)

@dynamic elements;

void CGPathElementEnumerationCallback(void *info, const CGPathElement *cgElement)
{
    NSMutableArray* elements = (__bridge NSMutableArray*)info;
    UIBezierPathElement* element = [UIBezierPathElement elementWithCGPathElement:cgElement];
    [elements addObject:element];
}

- (CGPoint) firstPoint
{
    UIBezierPathElement* element = self.elements.firstObject;
    return element.point;
}

- (CGPoint) lastPoint
{
    UIBezierPathElement* element = self.elements.lastObject;
    return element.point;
}

- (CGFloat) length
{
    NSMutableArray* elements = [self getElements];
    CGFloat length = 0.0;
    NSInteger size = elements.count;
    if (size > 0) {
        CGPoint prevPoint = ((UIBezierPathElement*)elements[0]).point;
        for (int i = 0; i < size; ++i) {
            UIBezierPathElement* element = elements[i];
            length += [element length:prevPoint];
            prevPoint = element.point;
        }
    }
    
    return length;
}

- (UIBezierPath*) bezierPathByTrimmingToLength:(float) trimLength
{
    if (trimLength >= [self length]) {
        return self;
    }
    
    float length = 0.0;
    CGPoint closePoint, lastPoint;
    UIBezierPath* newPath = [UIBezierPath bezierPath];
    
    for (UIBezierPathElement* element in self.elements) {
        float elementLength;
        float remainingLength = trimLength - length;
        
        switch (element.type) {
            case kCGPathElementMoveToPoint:
                [newPath moveToPoint:element.point];
                closePoint = lastPoint = element.point;
                continue;
                
            case kCGPathElementAddLineToPoint:
                elementLength = CGPointDistance(lastPoint, element.point);
                if (length + elementLength <= trimLength)
                    [newPath addLineToPoint:element.point];
                else
                {
                    float f = remainingLength / elementLength;
                    [newPath addLineToPoint:CGPointMake (lastPoint.x + f * (element.point.x - lastPoint.x), lastPoint.y + f * (element.point.y - lastPoint.y))];
                    return newPath;
                }
                
                length += elementLength;
                lastPoint = element.point;
                break;
                
            case kCGPathElementAddCurveToPoint:
            {
                elementLength = [element length:lastPoint];
                if (length + elementLength <= trimLength)
                    [newPath addCurveToPoint:element.point controlPoint1:element.ctrlPoint1 controlPoint2:element.ctrlPoint2];
                else
                {
                    CGPoint bezier[4] = { lastPoint, element.ctrlPoint1, element.ctrlPoint2, element.point };
                    CGPoint bez1[4], bez2[4];
                    subdivideBezierAtLength (bezier, bez1, bez2, remainingLength, kDefaultTrimEpsilon);
                    [newPath addCurveToPoint:bez1[3] controlPoint1:bez1[1] controlPoint2:bez1[2]];
                    return newPath;
                }
                
                length += elementLength;
                lastPoint = element.point;
                break;
            }
                
            case kCGPathElementCloseSubpath:
                elementLength = CGPointDistance(lastPoint, closePoint);
                
                if (length + elementLength <= trimLength) {
                    [newPath closePath];
                }
                else
                {
                    float f = remainingLength / elementLength;
                    [newPath addLineToPoint:CGPointMake(lastPoint.x + f * (closePoint.x - lastPoint.x), lastPoint.y + f * (closePoint.y - lastPoint.y))];
                    return newPath;
                }
                
                length += elementLength;
                lastPoint = closePoint;
                break;
                
            default:
                break;
        }
    }
    
    return newPath;
}

- (UIBezierPath*) bezierPathByTrimmingFromLength:(float) trimLength
{
    if (trimLength <= 0 || [self length] < trimLength) {
        return self;
    }
    
    float length = 0.0;
    CGPoint closePoint, lastPoint;
    UIBezierPath* newPath = [UIBezierPath bezierPath];

    for (UIBezierPathElement* element in self.elements) {
        float elementLength;
        float remainingLength = trimLength - length;
        switch (element.type) {
            case kCGPathElementMoveToPoint:
                if (length > trimLength) {
                    [newPath moveToPoint:element.point];
                }
                closePoint = lastPoint = element.point;
                continue;
                
            case kCGPathElementAddLineToPoint:
                elementLength = [element length:lastPoint];
                
                if (length > trimLength)
                    [newPath addLineToPoint:element.point];
                else if (length + elementLength > trimLength)
                {
                    float f = remainingLength / elementLength;
                    [newPath moveToPoint:CGPointMake (lastPoint.x + f * (element.point.x - lastPoint.x), lastPoint.y + f * (element.point.y - lastPoint.y))];
                    [newPath addLineToPoint:element.point];
                }
                
                length += elementLength;
                lastPoint = element.point;
                break;
                
            case kCGPathElementAddCurveToPoint:
            {
                elementLength = [element length:lastPoint];
                if (length > trimLength)
                    [newPath addCurveToPoint:element.point controlPoint1:element.ctrlPoint1 controlPoint2:element.ctrlPoint2];
                else if (length + elementLength > trimLength)
                {
                    CGPoint bezier[4] = { lastPoint, element.ctrlPoint1, element.ctrlPoint2, element.point };

                    CGPoint bez1[4], bez2[4];
                    subdivideBezierAtLength (bezier, bez1, bez2, remainingLength, kDefaultTrimEpsilon);
                    [newPath moveToPoint:bez2[0]];
                    [newPath addCurveToPoint:bez2[3] controlPoint1:bez2[1] controlPoint2:bez2[2]];
                }
                
                length += elementLength;
                lastPoint = element.point;
                break;
            }
                
            case kCGPathElementCloseSubpath:
                elementLength = CGPointDistance(lastPoint, closePoint);
                
                if (length + elementLength <= trimLength) {
                    [newPath closePath];
                }
                else
                {
                    float f = remainingLength / elementLength;
                    [newPath addLineToPoint:CGPointMake(lastPoint.x + f * (closePoint.x - lastPoint.x), lastPoint.y + f * (closePoint.y - lastPoint.y))];
                    return newPath;
                }
                
                length += elementLength;
                lastPoint = closePoint;
                break;
                
            default:
                break;
        }
    }
    
    return newPath;
}

- (void) setElements:(NSMutableArray*) elements
{
    objc_setAssociatedObject(self, &PATH_ELEMENTS, elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray*) getElements
{
    return [self getElements:NO];
}

- (NSMutableArray*) getElements:(BOOL) needUpdated
{
    NSMutableArray* elements = objc_getAssociatedObject(self, &PATH_ELEMENTS);
    BOOL collected = YES;
    if (elements == nil) {
        collected = NO;
        elements = [NSMutableArray array];
    }
    
    if (!collected || needUpdated) {
        [elements removeAllObjects];
        void CGPathElementEnumerationCallback(void *info, const CGPathElement *element);
        CGPathApply(self.CGPath, (void*)elements, CGPathElementEnumerationCallback);
    }

    objc_setAssociatedObject(self, &PATH_ELEMENTS, elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return elements;
}

- (void) updatePathElements
{
    NSMutableArray* elements = objc_getAssociatedObject(self, &PATH_ELEMENTS);
    if (elements == nil) {
        elements = [NSMutableArray array];
    }
    else {
        [elements removeAllObjects];
    }
    void CGPathElementEnumerationCallback(void *info, const CGPathElement *element);
    CGPathApply(self.CGPath, (void*)elements, CGPathElementEnumerationCallback);
    [self setElements:elements];
}

@end
