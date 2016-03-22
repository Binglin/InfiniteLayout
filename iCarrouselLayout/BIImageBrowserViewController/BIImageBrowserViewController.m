//
//  BIImageBrowserViewController.m
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/21.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import "BIImageBrowserViewController.h"
#import "iCarrouselContainerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BIImageBrowserViewController ()

@property (nonatomic, strong) BIImageBrowserContainerView *containerView;

@end


@implementation BIImageBrowserViewController

- (iCarrouselContainerView *)containerView{
    if (!_containerView) {
        _containerView = [[BIImageBrowserContainerView alloc] initWithFrame:self.view.bounds];
        __weak BIImageBrowserViewController *_weak_self = self;
        [_containerView setLayout:[BIImageBrowserLayout new]];
        _containerView.cellConfiguration = ^(iCarrouselImageCollectionViewCell * cell, NSIndexPath *indexPath){
            __strong BIImageBrowserViewController *self = _weak_self;
            [cell.infiniteImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[indexPath.section]]];
        };
    }
    return _containerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.containerView];
    self.containerView.dataArr = self.imageArr;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)]];
    
    BIImageBrowserLayout *layout = (BIImageBrowserLayout *)self.containerView.layout;
    layout.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.selectIndexPath.row];
    layout.sourceLayout    = self.sourceLayout;
    
    
    layout.show = YES;
//    [self.containerView.collectionView performBatchUpdates:^{
//        [self.containerView.collectionView reloadItemsAtIndexPaths:@[layout.selectIndexPath]];
//    } completion:nil];
    
    [self.containerView showPage:self.selectIndexPath.row animate:TRUE];

}



- (void)showFromViewController:(UIViewController *)controller{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    [controller presentViewController:self animated:YES completion:nil];
}

#pragma mark - action
- (void)tapped:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end



@implementation BIImageBrowserLayout

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attri = [super layoutAttributesForItemAtIndexPath:indexPath];
    if ([indexPath isEqual:self.selectIndexPath]) {
        //animate
        CGRect frame = [self.sourceLayout layoutAttributesForItemAtIndexPath:indexPath].frame;
        [self.sourceLayout.collectionView convertRect:frame toView:self.collectionView];
        if (self.show == NO) {
            attri.frame = frame;
        }
    }
    return attri;
}


@end



@implementation BIImageBrowserContainerView

- (void)initFlowLayout{
    BIImageBrowserLayout *layout = [BIImageBrowserLayout new];
    [self setLayout:layout];
}

@end

//@implementation BIImageBrowserCollectionCell
//
//- (void)setItem:(NSString *)urlStr{
//    self
//}

//@end


