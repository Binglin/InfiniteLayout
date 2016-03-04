//
//  InfiniteScrollContainerView.m
//
//
//  Created by 郑林琴 on 15/6/21.
//  Copyright (c) 2015年 郑林琴 All rights reserved.
//

#import "InfiniteScrollContainerView.h"
#import "InfiniteScrollFlowLayout.h"
#import "BIInfiniteProgressView.h"
#import "InfiniteSmallItemFlowLayout.h"
#import "UICollectionViewCell+setData.h"


#pragma mark - infinite type views

@interface InfiniteScrollContainerView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_scrollContainer;
    NSTimer *_timer;
    
    
    UIProgressView *_progress;
    
    BIInfiniteProgressView *_biProgress;
    
    @public
    UIPageControl *_pageControl;
    InfiniteScrollFlowLayout *_infiniteFlowLayout;
}

- (void)initFlowLayout;
- (void)initPageControl;

@end

@implementation InfiniteScrollContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initFlowLayout];
        _scrollContainer = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_infiniteFlowLayout];
        _scrollContainer.backgroundColor = [UIColor clearColor];
        _scrollContainer.dataSource = self;
        _scrollContainer.delegate   = self;
        _scrollContainer.pagingEnabled = YES;
        _scrollContainer.showsHorizontalScrollIndicator = NO;

        [self addSubview:_scrollContainer];
        [self registerCollectionCells];
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progress.frame = CGRectMake(20, 20, 200, 20);

        [self initPageControl];
        
        _biProgress = [[BIInfiniteProgressView alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
        [self addSubview:_biProgress];
        
        self.backgroundColor = [UIColor lightGrayColor];

    }
    return self;
}

- (void)initPageControl{
    _pageControl = [UIPageControl new];
    [self addSubview:_pageControl];
    
    _pageControl.frame = ({CGRect frame = _pageControl.frame;
        frame.origin.x = CGRectGetMidX(self.bounds) - CGRectGetWidth(frame)/2.f ;
        frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(frame) - 10.f;
        frame;});
    _pageControl.numberOfPages = 5;
}

- (void)initFlowLayout{
    _infiniteFlowLayout = [InfiniteScrollFlowLayout new];
    _infiniteFlowLayout.itemSize = ({CGSize size = self.bounds.size;
        size.width  -= 4;
        size.height -= 4;
        size;});
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self  stopTimer];
    [self  startTimer];
}

- (void)registerCollectionCells{
    [_scrollContainer registerClass:[InfiniteImageViewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([InfiniteImageViewCollectionViewCell class])];
}

#pragma mark - data
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InfiniteImageViewCollectionViewCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InfiniteImageViewCollectionViewCell class]) forIndexPath:indexPath];
    
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
    _biProgress.pageNumber = dataArr.count;
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    InfiniteScrollFlowLayout *infiniteFlowLayout = (InfiniteScrollFlowLayout *)_scrollContainer.collectionViewLayout;
    [infiniteFlowLayout scrollViewDidScroll];
     _pageControl.currentPage = _infiniteFlowLayout.currentPage;
    _progress.progress = _infiniteFlowLayout.progress;
    _biProgress.progress = _infiniteFlowLayout.progress;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

#pragma mark - timer
- (void)startTimer{
    if (self.dataArr.count > 1) {
        _timer = [NSTimer timerWithTimeInterval:2.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
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

@end





@implementation InfiniteScrollView

- (void)initFlowLayout{
    _infiniteFlowLayout = [[InfiniteSectionFlowLayout alloc] init];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

@end


@implementation SmallItemScrollView

- (void)initFlowLayout{
    _infiniteFlowLayout = [[InfiniteSmallItemFlowLayout alloc] init];
    _infiniteFlowLayout.itemSize = CGSizeMake(200, 180);
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
   NSArray *visiableCells = [_infiniteFlowLayout.collectionView visibleCells];
    for (UICollectionViewCell * cell in visiableCells) {
        CGRect cellFrame = [cell convertRect:cell.bounds toView:self];
        if (CGRectContainsPoint(cellFrame, CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f)))
        {
            NSLog(@"contain %@ %@",NSStringFromCGRect(cellFrame),[_infiniteFlowLayout.collectionView indexPathForCell:cell]);
            [_infiniteFlowLayout.collectionView setContentOffset:CGPointMake(cell.center.x - CGRectGetWidth(scrollView.frame)/2.f, 0) animated:YES];
            _pageControl.currentPage = [_infiniteFlowLayout.collectionView indexPathForCell:cell].section;
        }
    }
}

@end



#pragma mark - cell
@interface InfiniteImageViewCollectionViewCell (){
    UILabel *label;
}

@end
@implementation InfiniteImageViewCollectionViewCell

-  (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.infiniteImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.infiniteImageView];

    }
    return self;
}

- (void)setItem:(NSString *)cellItem{
    NSLog(@"%@",cellItem);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cellItem]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.infiniteImageView.image = image;
        });
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];
    label.frame = self.bounds;
}

- (void)setText:(NSString *)text{
    label.text = text;
}

@end
