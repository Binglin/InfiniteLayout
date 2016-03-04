//
//  InfiniteSmallItemFlowLayout.m
//  BLExampleWorkspace
//
//  Created by 郑林琴 on 15/6/28.
//  Copyright (c) 2015年 Binglin All rights reserved.
//

#import "InfiniteSmallItemFlowLayout.h"

@implementation InfiniteSmallItemFlowLayout


- (CGSize)collectionViewContentSize{
    return CGSizeMake(120 * [self.collectionView numberOfSections], 150.f);
}

- (void)configurationLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes withIndex:(NSIndexPath *)indexPath{
    attributes.size = CGSizeMake(100, 120.f);
    attributes.center = CGPointMake(indexPath.section * 120.f + 60.f, 75.f);
}
@end
