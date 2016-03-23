//
//  BIActivityViewController.h
//  BIDimmerViewController
//
//  Created by ET|冰琳 on 15/11/13.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import "BIDimmerViewController.h"



@interface BIActivityAction : NSObject 

+ (instancetype)actionViewActivityTitle:(NSString *)title image:(UIImage *)imageName action:(dispatch_block_t)action;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) dispatch_block_t activityAction;

@end




@interface BIActivityViewController : BIDimmerViewController

//一行数量不满时是否空隙平均
@property (nonatomic, assign) BOOL equalSpace;
- (void)addAction:(BIActivityAction *)action;
@property (nonatomic, assign) CGFloat pageControlViewHeight;


@end





