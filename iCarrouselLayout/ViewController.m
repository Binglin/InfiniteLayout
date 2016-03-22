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

#import "LatticesTableViewCell.h"
#import "LatticeLayout.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BIImageBrowserTransition *transition;
@property (nonatomic, strong) NSArray *cellData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain
                      ];
        [_tableView registerClass:[LatticesTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    
    self.transition = [BIImageBrowserTransition new];
    
    iCarrouselContainerView *scroll = [[iCarrouselContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
   NSArray *arr = @[@"http://huaban.com/go/?pin_id=598248676",
                       @"http://huaban.com/go/?pin_id=598248865",
                       @"http://huaban.com/go/?pin_id=598248999",
//                       @"http://huaban.com/go/?pin_id=598249074",
                       @"http://huaban.com/go/?pin_id=598249234"];
    
    
    self.cellData = @[
                      @[@"http://huaban.com/go/?pin_id=598248676"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249074"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249074",
                        @"http://huaban.com/go/?pin_id=598249234"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249074",
                        @"http://huaban.com/go/?pin_id=598249234",
                        @"http://huaban.com/go/?pin_id=598249234"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249074",
                        @"http://huaban.com/go/?pin_id=598249234",
                        @"http://huaban.com/go/?pin_id=598249074",
                        @"http://huaban.com/go/?pin_id=598249234"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249074",
                        @"http://huaban.com/go/?pin_id=598249234",
                        @"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999"],
                      
                      @[@"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249234",
                        @"http://huaban.com/go/?pin_id=598248676",
                        @"http://huaban.com/go/?pin_id=598248865",
                        @"http://huaban.com/go/?pin_id=598248999",
                        @"http://huaban.com/go/?pin_id=598249074",
                        @"http://huaban.com/go/?pin_id=598249234"]];
    
    
    
//    scroll.pageStyle = iCarrouselPageStyleLabel;
//    scroll.dataArr = arr;
//    
//    scroll.cellConfiguration = ^(iCarrouselImageCollectionViewCell *cell, NSIndexPath *index){
//        cell.infiniteImageView.image = nil;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:arr[index.section]]]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                cell.infiniteImageView.image = image;
//            });
//        });
//    };
//    [self.view addSubview:scroll];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [self.view addGestureRecognizer:tap];
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

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellData.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LatticesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setItem:self.cellData[indexPath.row]];

    
    cell.selectBlock = ^(NSIndexPath *index){
        
        BIImageBrowserViewController *browser = [BIImageBrowserViewController new];
        browser.sourceLayout = [(LatticesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] layout];
        browser.selectIndexPath = index;
        browser.imageArr     = self.cellData[indexPath.row];
        [browser showFromViewController:self];
    };
    return cell;
    
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSArray *d = self.cellData[indexPath.row];
    return [LatticeLayout heightForCount:d.count] + 10;
}



@end
