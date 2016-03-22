//
//  LatticesTableViewCell.h
//  iCarrouselLayout
//
//  Created by 郑林琴 on 16/3/22.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatticeLayout.h"


typedef void(^LatticesSelectBlock)(NSIndexPath *indexPath);

@interface LatticesTableViewCell : UITableViewCell

@property (nonatomic, readonly) LatticeLayout *layout;
@property (nonatomic, copy) LatticesSelectBlock selectBlock;

- (void)setItem:(NSArray *)cellItem;

@end
