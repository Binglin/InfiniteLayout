//
//  LatticeLayout.h
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/22.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import <UIKit/UIKit.h>


//格子布局 1 - 9

@interface LatticeLayout : UICollectionViewLayout

+ (CGFloat)heightForCount:(NSInteger)count;

@property (nonatomic, assign) NSInteger totalCount;

@end
