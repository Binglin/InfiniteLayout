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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
//    InfiniteScrollView *infinite = [[InfiniteScrollView alloc] initWithFrame:CGRectMake(0, 150, 320, 100)];
//    [self.view addSubview:infinite];
//    
//    infinite.dataArr = scroll.dataArr;
//    
//    SmallItemScrollView *smallItem = [[SmallItemScrollView alloc] initWithFrame:CGRectMake(0, 280.f, 320, 150)];
//    smallItem.dataArr = scroll.dataArr;
//    [self.view addSubview:smallItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
