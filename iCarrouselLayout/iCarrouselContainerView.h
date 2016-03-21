//
//  InfiniteScrollContainerView.h
//
//
//  Created by 郑林琴 on 15/6/21.
//  Copyright (c) 2015年 郑林琴 All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    iCarrouselPageStyleNone = 0,
    iCarrouselPageStylePageControl = 1,
    iCarrouselPageStyleProgressView,
    iCarrouselPageStyleLabel,
} iCarrouselPageStyle;

#pragma mark - infinite type views

typedef void(^InfiniteCellConfiguration)(__kindof UICollectionViewCell * cell, NSIndexPath *indexPath);

@interface iCarrouselContainerView : UIView

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy  ) InfiniteCellConfiguration cellConfiguration;
@property (nonatomic, assign) iCarrouselPageStyle pageStyle;

//自动滚动 default YES
@property (nonatomic, assign) BOOL autoCarrousel;
@property (nonatomic, assign) CGFloat carrouselInterval;

- (void)startCarrousel;
- (void)stopCarrousel;





@end



/** banner view*/
@interface InfiniteScrollView : iCarrouselContainerView

@end


@interface SmallItemScrollView : iCarrouselContainerView

@end



#pragma mark - cell
@interface iCarrouselImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *infiniteImageView;

@end

