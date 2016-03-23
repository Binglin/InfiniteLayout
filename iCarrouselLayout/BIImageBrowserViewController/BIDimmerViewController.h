//
//  BIDimmerViewController.h
//  BIDimmerViewController
//
//  Created by 郑林琴 on 15/11/10.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDimmerViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, assign)           CGFloat animateTime;

- (void)dismissAlertCompletion:(void(^)())competion;

- (void)showFromView:(UIView *)view;

@end
