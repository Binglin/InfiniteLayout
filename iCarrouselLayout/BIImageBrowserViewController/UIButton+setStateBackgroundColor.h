//
//  UIButton+setStateBackgroundColor.h
//  AlertController
//
//  Created by ET|冰琳 on 15/11/10.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (setStateBackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


@end


@interface UIImage (pureColor)

+ (instancetype)imageFromColor:(UIColor *)color;

@end
