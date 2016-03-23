//
//  BIAlertViewController.h
//  BIDimmerViewController
//
//  Created by ET|冰琳 on 15/11/10.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDimmerViewController.h"

typedef enum : NSUInteger {
    BIAlertControllerStyleActionSheet,
    BIAlertControllerStyleWechat,//微信保存图片弹出框
} BIAlertControllerStyle;




@interface BIAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title action:(dispatch_block_t)action;

@end



@interface BIAlertViewController : BIDimmerViewController

- (void)addAction:(BIAlertAction *)action;

@end
