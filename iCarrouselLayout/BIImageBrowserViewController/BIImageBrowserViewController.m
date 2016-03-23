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
#import "BIAlertViewController.h"

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

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.view addGestureRecognizer:longPress];
    
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
    NSIndexPath *indexPath = [self.containerView.collectionView indexPathForItemAtPoint:[tap locationInView:self.containerView]];
    BIImageBrowserCollectionViewCell *cell = (BIImageBrowserCollectionViewCell *)[self.containerView.collectionView cellForItemAtIndexPath:indexPath];
    [cell animateScaleImage];
}

- (void)longPressed:(UILongPressGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.containerView.collectionView indexPathForItemAtPoint:[press locationInView:self.containerView.collectionView]];
        BIImageBrowserCollectionViewCell *cell = (BIImageBrowserCollectionViewCell *)[self.containerView.collectionView cellForItemAtIndexPath:indexPath];
        [self saveImage:cell.imageView.image];
        
        if (cell.imageView.image) {
            
            BIAlertViewController *alert = [BIAlertViewController new];
            
            BIAlertAction *saveAction = [BIAlertAction actionWithTitle:@"保存图片" action:^{
                [self saveImage:cell.imageView.image];
            }];
            
            BIAlertAction *cancel = [BIAlertAction actionWithTitle:@"取消" action:nil];
            
            /*[alert addAction:shareImageAction];*/
            [alert addAction:saveAction];
            [alert addAction:cancel];
            [alert showFromView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

- (void)saveImage:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)saveImageSuceed{
    //[[HUDSinglaton shareSinglaton] showHUDThenHideWithText:@"已保存至系统相册" andView:[UIApplication sharedApplication].keyWindow];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [self saveImageSuceed];
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


