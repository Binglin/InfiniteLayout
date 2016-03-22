//
//  LatticeLayout.m
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/22.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import "LatticeLayout.h"

static CGFloat const LatticeLayoutmodOneHeight = 105;
static CGFloat const LatticeLayoutmodTwoHeight = 100;
static CGFloat const LatticeLayoutEdgeLeftRight = 40;
static CGFloat const LatticeLayoutItemSpace     = 5;

#define  LatticeLayoutScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  LatticeLayoutScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  LatticeLayoutRatio(x)      ((x / 320.f) * ([UIScreen mainScreen].bounds.size.width))



@implementation LatticeLayout

+ (CGFloat)heightForCount:(NSInteger)count{
    switch (count) {
        case 0:
            return 0;
        case 1:
            return LatticeLayoutmodOneHeight;
        case 2:
            return LatticeLayoutmodTwoHeight;
        case 3:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3;
        case 4:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3 + LatticeLayoutItemSpace + LatticeLayoutmodOneHeight;
        case 5:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3 + LatticeLayoutItemSpace + LatticeLayoutmodTwoHeight;
        case 6:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3 * 2 + LatticeLayoutItemSpace;
        case 7:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3 * 2 + LatticeLayoutItemSpace * 2 + LatticeLayoutmodOneHeight ;
        case 8:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3 * 2 + LatticeLayoutItemSpace * 2 + LatticeLayoutmodTwoHeight;
        case 9:
            return (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2) / 3 * 3 + LatticeLayoutItemSpace * 2;
            
        default:
            return 300;
    }
}

- (nullable NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray<UICollectionViewLayoutAttributes *> * a = [NSMutableArray new];
    for (int i = 0; i < self.totalCount; ++ i) {
        [a addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    return a;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
//    NSInteger firstLineColumn = self.totalCount % 3;
    NSInteger column = self.totalCount % 3;
    
    if (column == 0) {
        column = 3;
    }
    
    CGFloat height = LatticeLayoutmodOneHeight;
    if (column == 2) {
        height = LatticeLayoutmodTwoHeight;
    }else if (column == 3){
        height = (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - 2 * LatticeLayoutItemSpace) / 3;
    }
    
    if (indexPath.row < column) {
        
        CGFloat zeroRowWidth = (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - (column - 1) * LatticeLayoutItemSpace) / column;
        attri.frame = CGRectMake((zeroRowWidth + LatticeLayoutItemSpace) * (indexPath.row), 0, zeroRowWidth, height);
    }else{
        NSInteger tColumn = (indexPath.row - column) % 3;
        NSInteger tRow    = (indexPath.row - column - tColumn) / 3 + 1;
        CGFloat rowWidth = (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - 2 * LatticeLayoutItemSpace) / 3;
        attri.frame = CGRectMake((rowWidth + LatticeLayoutItemSpace) * (tColumn), height + tRow * LatticeLayoutItemSpace + (tRow - 1) * rowWidth , rowWidth, rowWidth);
    }

    
    return attri;
}

@end
