//
//  InfiniteScrollContainerView.h
//
//
//  Created by 郑林琴 on 15/6/21.
//  Copyright (c) 2015年 郑林琴 All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - infinite type views

typedef void(^InfiniteCellConfiguration)(__kindof UICollectionViewCell * cell, NSIndexPath *indexPath);

@interface InfiniteScrollContainerView : UIView

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) InfiniteCellConfiguration cellConfiguration;

@end



/** banner view*/
@interface InfiniteScrollView : InfiniteScrollContainerView

@end


@interface SmallItemScrollView : InfiniteScrollContainerView

@end


#pragma mark - cell
@interface InfiniteImageViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *infiniteImageView;

@end

