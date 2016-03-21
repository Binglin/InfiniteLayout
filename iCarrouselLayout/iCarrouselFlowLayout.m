//
//  InfiniteScrollFlowLayout.m
//
//
//  Created by 郑林琴 on 15/6/21.
//  Copyright (c) 2015年 郑林琴 All rights reserved.
//

#import "iCarrouselFlowLayout.h"





@interface iCarrouselFlowLayout ()

@property (nonatomic, assign) CGFloat progress;


@end


@implementation iCarrouselFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.itemSize = CGSizeMake(100, 100);
        self.cacheNumber = 1;
        self.infinite = YES;
    }
    return self;
}

- (CGSize)collectionViewContentSize{
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    NSUInteger sectionRowNumber = [self self_pageCount];
    if (sectionRowNumber <= 1) {
        return CGSizeMake(width, CGRectGetHeight(self.collectionView.frame));
    }
    return CGSizeMake(width * (sectionRowNumber + self.cacheNumber), CGRectGetHeight(self.collectionView.frame));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *elementsAttributes = [super layoutAttributesForElementsInRect:rect];
    if (elementsAttributes == nil) {
        
        NSMutableArray* attributes = [NSMutableArray array];
        
        for (int section = 0; section < self.collectionView.numberOfSections; section ++) {
            for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:section]; i++) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:section];
                [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            }
        }
        
        return attributes;
    }
    return elementsAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    
    NSUInteger page = [self self_pageCount];
    

    [self configurationLayoutAttributes:attributes withIndex:indexPath];
    
    if (self.infinite && (contentOffsetX > page * width - width)){
        if (indexPath.section == 0) {
            attributes.center = CGPointMake(attributes.center.x + page * width, attributes.center.y);
        }
    }
    
    return attributes;
}

//configuration center size
- (void)configurationLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes withIndex:(NSIndexPath *)indexPath{
    attributes.center = CGPointMake( CGRectGetWidth(self.collectionView.frame) * indexPath.section + CGRectGetWidth(self.collectionView.frame)/2.f, CGRectGetHeight(self.collectionView.frame)/2);
    attributes.size = self.itemSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return self.infinite;
}


- (void)scrollViewDidScroll
{
    //无限循环....
    
    NSInteger numCount     = [self self_pageCount];

    CGFloat targetX    = self.collectionView.contentOffset.x;
    CGFloat item_width = self.collectionView.frame.size.width;
    
    _currentPage = (int)(targetX/item_width) % numCount;
    
    CGFloat maxOffset = (self.collectionView.contentSize.width - item_width * self.cacheNumber);
    
    
    if (numCount >= 2)
    {
        if (targetX < 0 ) {
            [self.collectionView setContentOffset:CGPointMake(targetX + item_width * numCount, 0)];
        }
        else if (targetX > item_width * numCount)
        {
            [self.collectionView setContentOffset:CGPointMake(targetX - (item_width * numCount ) , 0)];
        }
    }
    
    self.progress = fmod(targetX, maxOffset)/(maxOffset);
    
//    NSLog(@"%f",self.progress);

//    self.progress = fmod(fmod(targetX,  maxOffset)/(maxOffset-item_width), 1.0f+0.001f);
}

/*self configuration*/
- (NSInteger)self_pageCount{
    return self.collectionView.numberOfSections;
}

@end





@implementation iCarrouselSectionFlowLayout

- (CGSize)itemSize{
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
}

- (void)configurationLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes withIndex:(NSIndexPath *)indexPath{
    
    CGFloat width = CGRectGetWidth(self.collectionView.frame);

    if (indexPath.row == 0) {
        
        attributes.center = CGPointMake( width * indexPath.section + width/2.f , CGRectGetHeight(self.collectionView.frame)/4);
        attributes.size = CGSizeMake(self.itemSize.width - 4, self.itemSize.height/2 - 4);
    }else if (indexPath.row == 1){
        attributes.center = CGPointMake(width * indexPath.section + width / 4, CGRectGetHeight(self.collectionView.frame)/4 * 3 );
        attributes.size = CGSizeMake(self.itemSize.width/2 - 4, self.itemSize.height / 2 - 4 );
    }else if (indexPath.row == 2){
        attributes.center = CGPointMake(width * indexPath.section + width / 4 * 3, CGRectGetHeight(self.collectionView.frame)/4 * 3 );
        attributes.size = CGSizeMake(self.itemSize.width/2 - 4, self.itemSize.height / 2 - 4 );
    }
}

@end
