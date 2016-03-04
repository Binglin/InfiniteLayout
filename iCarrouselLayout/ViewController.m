//
//  ViewController.m
//  iCarrouselLayout
//
//  Created by ET|冰琳 on 16/3/4.
//  Copyright © 2016年 Butterfly. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteScrollContainerView.h"
#import "BIInfiniteProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    InfiniteScrollContainerView *scroll = [[InfiniteScrollContainerView alloc] initWithFrame:CGRectMake(0, 10, 320, 160)];
    scroll.dataArr = @[@"http://huaban.com/go/?pin_id=598248676",
                       @"http://huaban.com/go/?pin_id=598248865",
                       @"http://huaban.com/go/?pin_id=598248999",
                       @"http://huaban.com/go/?pin_id=598249074",
                       @"http://huaban.com/go/?pin_id=598249234"];
    
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
