//
//  BIPageControl.h
//  PageControl
//
//  Created by Zhenglinqin on 15/5/28.
//  Copyright (c) 2015年 Binglin. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface BIPageControl : UIView


@property (nonatomic, assign)IBInspectable NSInteger    pageNumber;
@property (nonatomic, assign)IBInspectable NSInteger    selectPage;
@property (nonatomic, assign)IBInspectable CGFloat      indicatorWidth;
@property (nonatomic, assign)IBInspectable CGFloat      indicatorSpace;
@property (nonatomic, assign)IBInspectable BOOL         hideForSingle;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/**
 *  color
 */
@property (nonatomic, strong) IBInspectable UIImage      *normalImage;
@property (nonatomic, strong) IBInspectable UIImage      *selectImage;


@property (nonatomic, strong) IBInspectable UIColor      *normalColor;
@property (nonatomic, strong) IBInspectable UIColor      *selectColor;
@property (nonatomic, strong) IBInspectable UIColor      *strokeColor_normal;
@property (nonatomic, strong) IBInspectable UIColor      *strokeColor_select;


//最紧凑的size
- (CGSize)instrictSize;

@end
