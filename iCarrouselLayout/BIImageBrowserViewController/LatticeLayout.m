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
static CGFloat const LatticeLayoutItemSpace     = 10;

#define  LatticeLayoutScreenWidth   [UIScreen mainScreen].bounds.size.width
#define  LatticeLayoutScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  LatticeLayoutRatio(x)      ((x / 320.f) * ([UIScreen mainScreen].bounds.size.width))



@implementation LatticeLayout

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger mod = self.totalCount % 3;
    
    if (mod == 1) {
        if (indexPath.row == 0) {
            attri.frame = CGRectMake(0, 0, LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight, LatticeLayoutmodOneHeight);
        }
        
        
    }else if (mod == 2){
        if (indexPath.row <= 1) {
            CGFloat zeroRowWidth = (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace)/2.0;
            attri.frame = CGRectMake(indexPath.row * zeroRowWidth + indexPath.row * LatticeLayoutItemSpace, 0, LatticeLayoutItemSpace, LatticeLayoutmodTwoHeight);
        }
    }
    // mod = 0
    else{
        if (indexPath.row <= 2) {
            CGFloat zeroRowWidth = (LatticeLayoutScreenWidth - LatticeLayoutEdgeLeftRight - LatticeLayoutItemSpace * 2)/3.0;
            attri.frame = CGRectMake(indexPath.row * zeroRowWidth + indexPath.row * LatticeLayoutItemSpace, 0, LatticeLayoutItemSpace, LatticeLayoutmodTwoHeight);
        }
    }
    
    return attri;
}

@end
