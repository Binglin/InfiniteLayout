//
//  BIPageControl.m
//  PageControl
//
//  Created by Zhenglinqin on 15/5/28.
//  Copyright (c) 2015年 Binglin. All rights reserved.
//

#import "BIPageControl.h"


@interface BIPageControl ()
{
    NSMutableArray *_pageItems;
}

@end


@implementation BIPageControl

#pragma mark - init
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _pageItems = [NSMutableArray new];
    _selectPage = 0;
    _indicatorWidth = 10.0f;
    _hideForSingle  = YES;
    _edgeInsets = UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f);
    _indicatorSpace = 2.0f;
    _selectColor = [UIColor redColor];
    _normalColor = [UIColor whiteColor];
    _pageNumber = 3;
}

#pragma mark - property override
- (void)setPageNumber:(NSInteger)pageNumber{
    if (_pageNumber != pageNumber) {
        _pageNumber = pageNumber;
        [_pageItems removeAllObjects];
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        if (self.hideForSingle && _pageNumber <= 1) {
            return;
        }
        for (int i = 0; i < self.pageNumber; i ++) {
            CAShapeLayer *item = [self newLayerWithFrame:[self frameForItem:i]];
            [_pageItems addObject:item];
            [self.layer addSublayer:item];
        }
    }
    [self setNeedsDisplay];
}

- (void)setSelectPage:(NSInteger)selectPage{
    if (self.pageNumber == 0) {
        return;
    }
    if (_selectPage != selectPage) {
        [self resetForLayer:_pageItems[_selectPage] select:NO];
        _selectPage = selectPage;
        [self resetForLayer:_pageItems[_selectPage] select:YES];
    }
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
    [self setNeedsDisplay];
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [self setNeedsDisplay];
}


#pragma mark - dotView
- (CAShapeLayer *)newLayerWithFrame:(CGRect)frame{
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = frame;
    frame.origin = CGPointZero;
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, 1, 1)].CGPath;
    return _shapeLayer;
}

- (void)resetForLayer:(CAShapeLayer *)layer select:(BOOL)select{
    
    if (select) {
        if (self.selectImage) {
            layer.contents  = (id)self.selectImage.CGImage;
            layer.fillColor = [UIColor clearColor].CGColor;
        }else{
            layer.contents = nil;
            layer.fillColor = self.selectColor.CGColor;
        }
    }else{
        if (self.normalImage) {
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.contents  = (id)self.normalImage.CGImage;
        }else{
            layer.contents = nil;
            layer.fillColor = self.normalColor.CGColor;
        }
    }
    CGColorRef colorStroke = select ? self.strokeColor_select.CGColor : self.strokeColor_normal.CGColor;
    layer.strokeColor = colorStroke ? colorStroke : layer.fillColor;
}



#pragma mark - size
- (CGSize)instrictSize{
    return
    ({CGSize size;
        size.width = self.edgeInsets.left + self.edgeInsets.right +
                     self.indicatorSpace * (self.pageNumber - 1)
                     + self.pageNumber * self.indicatorWidth;
        size.height = self.edgeInsets.top + self.edgeInsets.bottom + self.indicatorWidth;
        size;
    });
}

- (void)sizeToFit{
    self.frame = ({CGRect frame = self.frame; frame.size = [self instrictSize]; frame;});
}

- (CGRect)frameForItem:(NSInteger)i{
    CGRect frame =
    ({
        CGRect itemFrame = CGRectZero;
        itemFrame.origin.x = self.edgeInsets.left + self.indicatorSpace * i
                             + self.indicatorWidth * i;
        itemFrame.origin.y = self.edgeInsets.top;
        itemFrame.size = CGSizeMake(self.indicatorWidth, self.indicatorWidth);
        itemFrame;
    });
    return frame;
}

- (void)drawRect:(CGRect)rect{
    
    for (int i = 0; i < self.pageNumber; i ++) {
        [self resetForLayer:_pageItems[i] select:i == _selectPage];
    }
}


@end
