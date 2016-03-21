//
//  BIImageBrowserViewController.m
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/21.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import "BIImageBrowserViewController.h"

@interface BIImageBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation BIImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[BIImageBrowserLayout new]];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[BIImageBrowserCollectionCell class] forCellWithReuseIdentifier:@"cell"];
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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
//    if (!CGRectContainsPoint(self.containerView.frame, location)) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

#pragma mark - 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BIImageBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
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



@end




@implementation BIImageBrowserCollectionCell


@end