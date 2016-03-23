//
//  BIActivityViewController.m
//  BIDimmerViewController
//
//  Created by ET|冰琳 on 15/11/13.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import "BIActivityViewController.h"
#import "UIButton+setStateBackgroundColor.h"


@implementation BIActivityAction

+ (instancetype)actionViewActivityTitle:(NSString *)title image:(UIImage *)imageName action:(dispatch_block_t)action{
    BIActivityAction *actionActivity = [[self.class alloc] init];
    actionActivity.title = title;
    actionActivity.image = imageName;
    actionActivity.activityAction = action;
    return actionActivity;
}

@end




@interface BIActivityGridLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger  columnCount;
@property (nonatomic, assign) NSInteger  rowCount;

- (CGSize)fitSize;
- (NSInteger)totalPageCountWithData:(NSInteger)totalDataCount;

@end



@implementation BIActivityGridLayout

- (instancetype)init{
    if (self = [super init]) {
        self.columnCount = 4;
        self.rowCount    = 2;
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 12;
        self.itemSize    = CGSizeMake(60, 75);
        self.minimumInteritemSpacing = (CGRectGetWidth([UIScreen mainScreen].bounds) - self.itemSize.width * self.columnCount)/(self.columnCount + 1);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}



- (CGSize)fitSize{
    CGSize normalSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), self.itemSize.height * self.rowCount + self.minimumLineSpacing * (self.rowCount + 1));
    return normalSize;
}

- (NSInteger)totalPageCountWithData:(NSInteger)totalDataCount{
    NSInteger aPageCount = self.columnCount * self.rowCount;
    NSInteger pageNumber = totalDataCount/aPageCount + 1;
    return pageNumber;
}

- (CGSize)collectionViewContentSize{
    NSInteger totalCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger aPageCount = self.columnCount * self.rowCount;

    NSInteger pageNumber = totalCount/aPageCount + 1;
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame) * pageNumber, CGRectGetHeight(self.collectionView.frame));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i ++) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.size = self.itemSize;
    NSInteger columnNumber = indexPath.row % self.columnCount;
    NSInteger rowNumber    = (indexPath.row - indexPath.row % self.columnCount)/self.columnCount;
    NSInteger page =  (NSInteger) (rowNumber / self.rowCount);
    NSInteger row  = rowNumber % self.rowCount;
    CGFloat centerX = self.minimumInteritemSpacing * (columnNumber + 1) + self.itemSize.width * ( columnNumber + 0.5) + page * [UIScreen mainScreen].bounds.size.width;
    
    CGFloat centerY = self.minimumLineSpacing * (row + 1) + self.itemSize.height * (row + 0.5);
    layoutAttributes.center = CGPointMake(centerX, centerY);
    
    return layoutAttributes;
}

@end




@protocol UIlistCellButtonDelegate <NSObject>

- (void)cellButtonActioned:(UIButton *)sender;

@end

@interface BIActivityCell : UICollectionViewCell

@property (nonatomic, strong) UIButton    *imageButton;
@property (nonatomic, strong) UILabel     *textLabel;
@property (nonatomic, assign) id<UIlistCellButtonDelegate> buttonDelegate;

@end

@implementation BIActivityCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageButton addTarget:self action:@selector(cellButtonActioned:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imageButton];
        
        self.textLabel = [UILabel new];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)cellButtonActioned:(UIButton *)sender{
    if (self.buttonDelegate) {
        [self.buttonDelegate cellButtonActioned:sender];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.imageButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));

    self.textLabel.frame = CGRectMake(0,//CGRectGetWidth(self.frame)/2.f - CGRectGetWidth(self.textLabel.frame)/2.f,
                                      CGRectGetMaxY(self.imageButton.frame) ,
                                      CGRectGetWidth(self.frame),//CGRectGetWidth(self.textLabel.frame),
                                      CGRectGetHeight(self.textLabel.frame));
    
}


@end


@interface BIActivityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIlistCellButtonDelegate>{
    UIButton *_cancelButton;
}


@property (nonatomic, strong) UIView *pageControlContainerView;
@property (nonatomic, strong) UIPageControl *pageControl;;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, assign) CGFloat buttonViewHeights;

@end

@implementation BIActivityViewController


- (NSMutableArray *)actions{
    @synchronized(self) {
        if (_actions == nil) {
            _actions = [NSMutableArray array];
        }
        return _actions;
    }
}

- (void)loadView{
    [super loadView];
    
    self.buttonViewHeights = 50;
    self.pageControlViewHeight = 0.5;
    
    self.pageControlContainerView = [UIView new];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.pageControlContainerView addSubview:self.pageControl];
    
        
    BIActivityGridLayout *gridLayout = [BIActivityGridLayout new];
    self.pageControl.numberOfPages = [gridLayout totalPageCountWithData:self.actions.count];

    self.collectionView = [[UICollectionView alloc] initWithFrame:({ CGRect frame = CGRectZero;
        CGSize gridSize = gridLayout.fitSize;
        
        if (self.actions.count <= gridLayout.columnCount) {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat itemHorizonWidth = self.actions.count * gridLayout.itemSize.width;
            
            CGFloat horizontalSpace = (screenWidth - itemHorizonWidth)/(self.actions.count + 1);
            CGFloat verticalSpace  = gridLayout.minimumLineSpacing * 2;
            gridLayout.minimumLineSpacing = verticalSpace ;
            if (self.equalSpace) {
                gridLayout.minimumInteritemSpacing = horizontalSpace;
            }
            gridSize.height = gridLayout.itemSize.height + gridLayout.minimumLineSpacing * 2;
        }
//
        if (self.actions.count <= gridLayout.columnCount * gridLayout.rowCount) {
//            self.pageControlViewHeight = 0;
            self.pageControlContainerView.hidden = YES;
        }

        frame.size = gridSize;
        
        frame;
    }) collectionViewLayout:gridLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[BIActivityCell class] forCellWithReuseIdentifier:@"BIActivityCell"];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.pageControlContainerView];
    self.pageControlContainerView.backgroundColor = [UIColor clearColor];
    self.pageControl.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.collectionView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, self.collectionView.frame.size.height + self.pageControlViewHeight , CGRectGetWidth([UIScreen mainScreen].bounds), self.buttonViewHeights);
    [btn addTarget:self action:@selector(canceledAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.containerView addSubview:btn];
    [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    self.pageControlContainerView.backgroundColor = [UIColor lightGrayColor];
    
    self.pageControl.currentPage   = 0;
    
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.frame = ({
        CGRect frame = self.collectionView.frame;
        CGFloat bottomHeight = self.pageControlViewHeight + self.buttonViewHeights + CGRectGetHeight(frame);
        frame.origin.y = CGRectGetHeight(self.view.frame) - bottomHeight;
        frame.size.height = bottomHeight;
        frame;
    });
    
    self.pageControlContainerView.frame = ({
        CGRect frame = CGRectZero;
        frame.origin.y = CGRectGetMaxY(self.collectionView.frame);
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = self.pageControlViewHeight;
        frame;
    });
}


- (void)addAction:(BIActivityAction *)action{
    [self.actions addObject:action];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.actions.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BIActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BIActivityCell" forIndexPath:indexPath];
    BIActivityAction *actionn = [self.actions objectAtIndex:indexPath.row];
    [cell.imageButton setImage:actionn.image forState:UIControlStateNormal];
    cell.textLabel.text  = actionn.title;
    cell.buttonDelegate  = self;
    cell.imageButton.tag = indexPath.row + 100;
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    NSInteger page = floor(contentOffset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = page;
}

#pragma mark - UIlistCellButtonDelegate
- (void)cellButtonActioned:(UIButton *)sender{
    NSInteger indexRow = sender.tag - 100;
    BIActivityAction *action = self.actions[indexRow];
    if (action.activityAction) {
        action.activityAction();
    }
}

#pragma mark - event
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self.view];
//    if (!CGRectContainsPoint(self.containerView.frame, location)) {
//        [self dismissAlertCompletion:nil];
//    }
//}

- (void)canceledAction:(UIButton *)sender{
    [self dismissAlertCompletion:nil];
}

@end
