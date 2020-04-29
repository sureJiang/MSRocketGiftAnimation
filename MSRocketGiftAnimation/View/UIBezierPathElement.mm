//
//  UIBezierPathElement.m
//  GiftAnimationDemo
//
//  Created by J. on 2/28/16.
//  Copyright © 2016 J. All rights reserved.
//

#import "UIBezierPath+Util.h"
#import "UIBezierPathElement.h"

static CGFloat kDefaultTrimEpsilon = 0.5;

static CGFloat CGPointDistance(CGPoint p0, CGPoint p1)
{
    //    CGFloat dx = p1.x - p2.x;
    //    CGFloat dy = p1.y - p2.y;
    //    CGFloat dist = sqrt(pow(dx, 2) + pow(dy, 2));
    //    return dist;
    return hypotf(p1.x - p0.x, p1.y - p0.y);
}

@implementation UIBezierPathElement

+ (instancetype) elementWithCGPathElement:(const CGPathElement*) element
{
    return [[self alloc] initWithCGPathElement:element];
}

- (instancetype) initWithCGPathElement:(const CGPathElement*) element
{
    self = [super init];
    self.type = element->type;
    switch (self.type) {
        case kCGPathElementMoveToPoint:
        case kCGPathElementAddLineToPoint:
            self.point = element->points[0];
            break;
        case kCGPathElementAddCurveToPoint:
            self.point = element->points[2];
            self.ctrlPoint1 = element->points[0];
            self.ctrlPoint2 = element->points[1];
            break;
        case kCGPathElementAddQuadCurveToPoint:
            self.point = element->points[1];
            self.ctrlPoint1 = element->points[0];
            self.ctrlPoint2 = element->points[0];
            break;
        default:
            break;
    }
    
    return self;
}

- (CGFloat) length:(CGPoint) prevPoint
{
    CGFloat length = 0.0;
    switch (self.type) {
        case kCGPathElementAddLineToPoint:
            length = CGPointDistance(prevPoint, self.point);
            break;
        case kCGPathElementAddCurveToPoint:
        case kCGPathElementAddQuadCurveToPoint:
        {
            CGPoint bezier[4] = { prevPoint, self.ctrlPoint1, self.ctrlPoint2, self.point };
            length = lengthOfBezier(bezier, kDefaultTrimEpsilon);
        }
            break;
        case kCGPathElementMoveToPoint:
        case kCGPathElementCloseSubpath:
            break;
    }

    return length;
}

//void CGPathElementWrapperEnumerationCallback(void *info, const CGPathElement *element)
//{
//    std::vector<CGPathElementWrapper>* elements = (std::vector<CGPathElementWrapper>*)info;
//    CGPathElementWrapper elementWrapper(element);
//    elements->push_back(elementWrapper);
//}
//
//void getElementWrapper(const CGPathRef& cgPath, std::vector<CGPathElementWrapper>& elements)
//{
//    elements.clear();
//    void CGPathElementWrapperEnumerationCallback(void *info, const CGPathElement *element);
//    CGPathApply(cgPath, (void*)&elements, CGPathElementWrapperEnumerationCallback);
//}

@end
