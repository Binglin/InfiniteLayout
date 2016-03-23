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
        _containerView.cellConfiguration = ^(BIImageBrowserCollectionViewCell * cell, NSIndexPath *indexPath){
            __strong BIImageBrowserViewController *self = _weak_self;
            cell.imageView.contentMode = UIViewContentModeCenter;
            cell.imageView.backgroundColor = [UIColor yellowColor];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[indexPath.section]]];
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
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTaped:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:tap];
    
    BIImageBrowserLayout *layout = (BIImageBrowserLayout *)self.containerView.layout;
    layout.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.selectIndexPath.row];
    layout.sourceLayout    = self.sourceLayout;
    [self.containerView.collectionView reloadData];
    
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

- (void)doubleTaped:(UITapGestureRecognizer *)tap{
    
//    NSLog(@"%d",tap.numberOfTapsRequired);
//    
//    return;
    
    NSIndexPath *indexPath = [self.containerView.collectionView indexPathForItemAtPoint:[tap locationInView:self.containerView]];
    BIImageBrowserCollectionViewCell *cell = (BIImageBrowserCollectionViewCell *)[self.containerView.collectionView cellForItemAtIndexPath:indexPath];
    [cell animateScaleImage];
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

- (void)animateIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.selectIndexPath.section) {
        //animate
        CGRect frame = [self.sourceLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]].frame;
        CGRect convertF = [self.sourceLayout.collectionView convertRect:frame toView:[UIApplication sharedApplication].keyWindow];
        
        CGRect originFrame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        
        BIImageBrowserCollectionViewCell *cell = (BIImageBrowserCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        CGFloat left = CGRectGetMinX(originFrame) - fmod(CGRectGetMinX(originFrame), CGRectGetWidth(self.collectionView.frame)) + CGRectGetMinX(convertF) - CGRectGetMinX(self.collectionView.frame);
        
        cell.frame = CGRectMake(left, CGRectGetMinY(convertF), convertF.size.width, convertF.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            cell.frame = originFrame;
        }];
    }
}

@end



@implementation BIImageBrowserContainerView

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTaped:)];
//        tap.numberOfTapsRequired = 2;
//        [self addGestureRecognizer:tap];
//    }
//    return self;
//}
//
//- (void)doubleTaped:(UITapGestureRecognizer *)tap{
//    
//}

- (void)initFlowLayout{
    BIImageBrowserLayout *layout = [BIImageBrowserLayout new];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    [self setLayout:layout];
}

- (void)registerCollectionCells{
    [self.collectionView registerClass:[BIImageBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

@end


@interface BIImageBrowserCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scaleView;

@end

@implementation BIImageBrowserCollectionViewCell

-  (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.scaleView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scaleView.delegate = self;
        self.scaleView.maximumZoomScale = 2.0;
        self.scaleView.showsHorizontalScrollIndicator = false;
        self.scaleView.showsVerticalScrollIndicator = false;
        
        [self.contentView addSubview:self.scaleView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.scaleView addSubview:self.imageView];
        
        self.contentView.backgroundColor = [UIColor orangeColor];
        
    }
    return self;
}

// zoomRect
- (void)animateScaleImage{
    if (self.scaleView.zoomScale > 1.0) {
        [self.scaleView setZoomScale:1.0 animated:YES];
    }else{
        [self.scaleView setZoomScale: 2.0 animated:YES];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end


