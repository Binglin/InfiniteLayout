//
//  BIImageBrowserViewController.h
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/21.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIImageBrowserViewController : UIViewController

@property (nonatomic, strong) UICollectionViewLayout *sourceLayout;
@property (nonatomic, strong) NSArray *imageArr;

- (void)showFromViewController:(UIViewController *)controller;

@end





@interface BIImageBrowserLayout : UICollectionViewFlowLayout

@end



@interface BIImageBrowserCollectionCell : UICollectionViewCell

@end
