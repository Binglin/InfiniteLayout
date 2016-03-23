//
//  LatticesTableViewCell.m
//  iCarrouselLayout
//
//  Created by 郑林琴 on 16/3/22.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import "LatticesTableViewCell.h"
#import "iCarrouselContainerView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LatticesTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LatticeLayout *layout;
@property (nonatomic, assign) NSArray * imageData;

@end



@implementation LatticesTableViewCell

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _layout = [LatticeLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[iCarrouselImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)setItem:(NSArray *)cellItem{
    self.imageData = cellItem;
    self.layout.totalCount = cellItem.count;
    [self.collectionView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = CGRectInset(self.bounds, 20, 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageData.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    iCarrouselImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.infiniteImageView sd_setImageWithURL:[NSURL URLWithString:self.imageData[indexPath.row]]];

    
    return cell;
}
#pragma mark -
- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(indexPath);
    }
}

@end
