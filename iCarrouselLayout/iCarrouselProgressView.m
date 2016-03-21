//
//  BIInfiniteProgressView.m
//  
//
//  Created by Zhenglinqin on 15/6/25.
//  Copyright (c) 2015年 Binglin All rights reserved.
//

#import "iCarrouselProgressView.h"

@interface iCarrouselProgressView (){
    UIView *_indicator;
    UIView *_tempIndicator;
    
    CGFloat _indicatorWidth;
    
    UIPanGestureRecognizer *_pan;
}

@end

@implementation iCarrouselProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (frame.size.height > 4.0) {
        frame.size.height = 4.0;
    }
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        
        _indicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 4.f)];
        _indicator.backgroundColor = [UIColor redColor];
        
        _tempIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 4.f)];
        _tempIndicator.backgroundColor = [UIColor redColor];
        
        [self addSubview:_indicator];
        [self addSubview:_tempIndicator];
        
        _indicator.layer.cornerRadius = 2.f;
        self.layer.cornerRadius = 2.0;
        _indicator.layer.masksToBounds = YES;
        _tempIndicator.layer.cornerRadius = 2.f;
        _tempIndicator.layer.masksToBounds = YES;

        
        self.pageNumber = 3;
        
        self.progress = 0;
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
        [self addGestureRecognizer:_pan];
    }
    return self;
}


- (void)setPageNumber:(NSInteger)pageNumber{
    _pageNumber = pageNumber;
    _indicator.frame = ({CGRect frame = _indicator.frame;
        frame.size.width = CGRectGetWidth(self.bounds)/pageNumber;
        frame;
    });
    _indicatorWidth = CGRectGetWidth(self.frame)/pageNumber;
    
}

- (void)setProgress:(CGFloat)progress{
    
    if (progress > 1.0f) {
        progress -= 1.f;
    }else if (progress < 0.f){
        progress += 1.f;
    }
    _progress = progress;
    
    CGFloat destinationX = CGRectGetWidth(self.bounds) * progress ;
    
    if (destinationX + _indicatorWidth > CGRectGetWidth(self.bounds)) {
        _indicator.frame = ({CGRect frame = _indicator.frame;
            frame.origin.x = destinationX ;
            frame.size.width = CGRectGetWidth(self.bounds) - destinationX;
            frame;
        });
        
        _tempIndicator.frame = ({CGRect frame = _tempIndicator.frame;
            CGFloat temp_width = _indicatorWidth - (CGRectGetWidth(self.bounds) - destinationX);
            frame.size.width = temp_width;
            frame;
        });
    }
    else{
        if (progress > 0) {
            _tempIndicator.frame = ({CGRect frame = _tempIndicator.frame;
                frame.size.width = 0;
                frame;
            });
        }
        _indicator.frame = ({CGRect frame = _indicator.frame;
            frame.origin.x = CGRectGetWidth(self.bounds) * progress ;
            frame.size.width = _indicatorWidth;
            frame;
        });
    }
    
}

- (void)paned:(UIPanGestureRecognizer *)pan{
    CGPoint trans = [pan translationInView:self];
    [pan setTranslation:CGPointZero inView:self];
    self.progress += trans.x/CGRectGetWidth(self.bounds);
}

@end
