//
//  InfiniteScrollFlowLayout.h
//  
//
//  Created by 郑林琴 on 15/6/21.
//  Copyright (c) 2015年 郑林琴 All rights reserved.
//

#import <UIKit/UIKit.h>


//section == 1
@interface InfiniteScrollFlowLayout : UICollectionViewLayout//UICollectionViewFlowLayout

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) NSUInteger cacheNumber;


//是否需要循环滚动
@property (nonatomic, assign) BOOL infinite;

//default is default_scroll_interval
@property (nonatomic, assign) CGFloat scrollInterval;


@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign,readonly) CGFloat progress;

- (void)scrollViewDidScroll;

- (void)configurationLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes withIndex:(NSIndexPath *)indexPath;


@end


//一个section为一屏
@interface InfiniteSectionFlowLayout : InfiniteScrollFlowLayout

@end

