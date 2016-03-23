//
//  UIButton+setStateBackgroundColor.m
//  AlertController
//
//  Created by ET|冰琳 on 15/11/10.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import "UIButton+setStateBackgroundColor.h"

@implementation UIButton (setStateBackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    [self setBackgroundImage:[[UIImage imageFromColor:backgroundColor] stretchableImageWithLeftCapWidth:0.5f topCapHeight:0.5f] forState:state];
}

@end


@implementation UIImage (pureColor)

+ (instancetype)imageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 2, 2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
