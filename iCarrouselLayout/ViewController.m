//
//  ViewController.m
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/4.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import "ViewController.h"
#import "iCarrouselContainerView.h"
#import "iCarrouselProgressView.h"

#import "BIImageBrowserViewController.h"
#import "BIImageBrowserTransition.h"

@interface ViewController ()

@property (nonatomic, strong) BIImageBrowserTransition *transition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.transition = [BIImageBrowserTransition new];
    
    iCarrouselContainerView *scroll = [[iCarrouselContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
   NSArray *arr = @[@"http://huaban.com/go/?pin_id=598248676",
                       @"http://huaban.com/go/?pin_id=598248865",
                       @"http://huaban.com/go/?pin_id=598248999",
//                       @"http://huaban.com/go/?pin_id=598249074",
                       @"http://huaban.com/go/?pin_id=598249234"];
    scroll.pageStyle = iCarrouselPageStyleLabel;
    scroll.dataArr = arr;
    
    scroll.cellConfiguration = ^(iCarrouselImageCollectionViewCell *cell, NSIndexPath *index){
        cell.infiniteImageView.image = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:arr[index.section]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.infiniteImageView.image = image;
            });
        });
    };
    [self.view addSubview:scroll];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap{
    BIImageBrowserViewController *iBrowser = [[BIImageBrowserViewController alloc] init];
    iBrowser.transitioningDelegate = self.transition;
    [iBrowser showFromViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
