//
//  BIInfiniteProgressView.h
//  BLExampleWorkspace
//
//  Created by Zhenglinqin on 15/6/25.
//  Copyright (c) 2015年 Binglin All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIInfiniteProgressView : UIView

@property (nonatomic, assign) CGFloat   progress;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) IBInspectable  BOOL hideForSingle;

@end
