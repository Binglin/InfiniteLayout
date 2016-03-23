//
//  InfiniteScrollContainerView.m
//
//
//  Created by 郑林琴 on 15/6/21.
//  Copyright (c) 2015年 郑林琴 All rights reserved.
//

#import "iCarrouselContainerView.h"
#import "iCarrouselFlowLayout.h"
#import "iCarrouselProgressView.h"
#import "iCarrouselSmallItemFlowLayout.h"
#import "UICollectionViewCell+setData.h"


const CGFloat default_scroll_interval = 3.0f;


#pragma mark - infinite type views

@interface iCarrouselContainerView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_scrollContainer;
    NSTimer *_timer;
}



@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) iCarrouselProgressView *iProgressView;
@property (nonatomic, strong) UILabel                *iPageLabel;
@property (nonatomic, strong) iCarrouselFlowLayout   *infiniteFlowLayout;

@end

@implementation iCarrouselContainerView

- (UICollectionView *)collectionView{
    return _scrollContainer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initFlowLayout];
        _scrollContainer = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.infiniteFlowLayout];
        _scrollContainer.backgroundColor = [UIColor clearColor];
        _scrollContainer.dataSource = self;
        _scrollContainer.delegate   = self;
        _scrollContainer.pagingEnabled = YES;
        _scrollContainer.showsHorizontalScrollIndicator = NO;

        [self addSubview:_scrollContainer];
        [self registerCollectionCells];

        self.pageStyle = iCarrouselPageStylePageControl;
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.carrouselInterval = default_scroll_interval;
//        self.autoCarrousel = YES;
    }
    return self;
}

#pragma mark - property
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        [self addSubview:_pageControl];
        _pageControl.frame = ({CGRect frame = _pageControl.frame;
            frame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(frame)/2.f ;
            frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(frame) - 10.f;
            frame;});
        _pageControl.numberOfPages = 1;
    }
    return _pageControl;
}

- (iCarrouselProgressView *)iProgressView{
    if (!_iProgressView) {
        _iProgressView = [[iCarrouselProgressView alloc] initWithFrame:CGRectMake(20, self.bounds.size.height - 20 - 5, self.bounds.size.width - 40, 5)];
    }
    return _iProgressView;
}

- (UILabel *)iPageLabel{
    if (!_iPageLabel) {
        _iPageLabel = [UILabel new];
        _iPageLabel.font = [UIFont systemFontOfSize:14.0];
        _iPageLabel.textAlignment = NSTextAlignmentRight;
        _iPageLabel.frame = CGRectMake(20 , CGRectGetHeight(self.bounds) - 20 - 20, CGRectGetWidth(self.bounds) - 40, 20);
    }
    return _iPageLabel;
}

- (void)setPageStyle:(iCarrouselPageStyle)pageStyle{
    _pageStyle = pageStyle;
    switch (pageStyle) {
        case iCarrouselPageStyleNone:{
            [_iPageLabel removeFromSuperview];
            [_iProgressView removeFromSuperview];
            [_pageControl removeFromSuperview];

            _iPageLabel = nil;
            _iProgressView = nil;
            _pageControl = nil;
            
            break;
        }
        case iCarrouselPageStylePageControl:{
            [_iPageLabel removeFromSuperview];    _iPageLabel = nil;
            [_iProgressView removeFromSuperview]; _iProgressView = nil;
            [self addSubview:self.pageControl];
            break;
        }
        case iCarrouselPageStyleProgressView:{
            [_iPageLabel removeFromSuperview];  _iPageLabel = nil;
            [_pageControl removeFromSuperview]; _pageControl = nil;
            [self addSubview:self.iProgressView];
            break;
        }
        case iCarrouselPageStyleLabel:{
            [_iProgressView removeFromSuperview]; _iProgressView = nil;
            [_pageControl removeFromSuperview];   _pageControl = nil;
            [self addSubview:self.iPageLabel];
            if (self.dataArr.count) {
                _iProgressView.pageNumber = self.dataArr.count;
            }
            break;
        }
    }
}

- (void)setAutoCarrousel:(BOOL)autoCarrousel{
    _autoCarrousel = autoCarrousel;
    if (autoCarrousel) {
        [self startCarrousel];
    }else{
        [self stopTimer];
    }
}

#pragma mark - super


#pragma mark -

- (void)initFlowLayout{
    _infiniteFlowLayout = [iCarrouselFlowLayout new];
    _infiniteFlowLayout.itemSize = ({CGSize size = self.bounds.size;
        size.width  -= 4;
        size.height -= 4;
        size;});
}

- (void)setLayout:(UICollectionViewLayout *)layout{
    self.infiniteFlowLayout = (iCarrouselFlowLayout *)layout;
}

- (UICollectionViewLayout *)layout{
    return self.infiniteFlowLayout;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self startCarrousel];
}

- (void)registerCollectionCells{
    [_scrollContainer registerClass:[iCarrouselImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([iCarrouselImageCollectionViewCell class])];
}

#pragma mark - data
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    iCarrouselImageCollectionViewCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.cellConfiguration) {
        self.cellConfiguration(collectCell, indexPath);
    }
    [collectCell setItem:self.dataArr[indexPath.section]];
    
    return collectCell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    _pageControl.numberOfPages = dataArr.count;
    _pageControl.currentPage   = 0;
    _iProgressView.pageNumber = dataArr.count;
    _iPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_infiniteFlowLayout.currentPage + 1, self.dataArr.count];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    iCarrouselFlowLayout *infiniteFlowLayout = self.infiniteFlowLayout;//(iCarrouselFlowLayout *)_scrollContainer.collectionViewLayout;
    [infiniteFlowLayout scrollViewDidScroll];
    
     _pageControl.currentPage = infiniteFlowLayout.currentPage;
    _iPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",infiniteFlowLayout.currentPage + 1, self.dataArr.count];
    _iProgressView.progress = infiniteFlowLayout.progress;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopCarrousel];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startCarrousel];
}

#pragma mark - timer
- (void)startTimer{
    if (self.dataArr.count > 1 && self.autoCarrousel) {
        _timer = [NSTimer timerWithTimeInterval:self.carrouselInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)nextPage{
    [_scrollContainer setContentOffset:CGPointMake(_scrollContainer.contentOffset.x + CGRectGetWidth(self.bounds), _scrollContainer.contentOffset.y) animated:YES];
}

- (void)showPage:(NSInteger)page animate:(BOOL)animate{
    [_scrollContainer setContentOffset:CGPointMake(_scrollContainer.contentOffset.x + CGRectGetWidth(self.bounds) * (page - _infiniteFlowLayout.currentPage), _scrollContainer.contentOffset.y) animated:animate];
    
}

- (void)startCarrousel{
    [self stopTimer];
    [self startTimer];
}

- (void)stopCarrousel{
    [self stopTimer];
}

@end





@implementation InfiniteScrollView

- (void)initFlowLayout{
    self.infiniteFlowLayout = [[iCarrouselSectionFlowLayout alloc] init];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

@end


@implementation SmallItemScrollView

- (void)initFlowLayout{
    self.infiniteFlowLayout = [[iCarrouselSmallItemFlowLayout alloc] init];
    self.infiniteFlowLayout.itemSize = CGSizeMake(200, 180);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollToDestination:scrollView];
}

- (void)scrollToDestination:(UIScrollView *)scrollView{
   NSArray *visiableCells = [self.infiniteFlowLayout.collectionView visibleCells];
    for (UICollectionViewCell * cell in visiableCells) {
        CGRect cellFrame = [cell convertRect:cell.bounds toView:self];
        if (CGRectContainsPoint(cellFrame, CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f)))
        {
            NSLog(@"contain %@ %@",NSStringFromCGRect(cellFrame),[self.infiniteFlowLayout.collectionView indexPathForCell:cell]);
            [self.infiniteFlowLayout.collectionView setContentOffset:CGPointMake(cell.center.x - CGRectGetWidth(scrollView.frame)/2.f, 0) animated:YES];
            self.pageControl.currentPage = [self.infiniteFlowLayout.collectionView indexPathForCell:cell].section;
        }
    }
}

@end



#pragma mark - cell
@interface iCarrouselImageCollectionViewCell ()

@end

@implementation iCarrouselImageCollectionViewCell

-  (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.infiniteImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.infiniteImageView];
    
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.infiniteImageView.frame = self.bounds;
}

@end
