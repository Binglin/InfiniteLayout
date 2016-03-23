//
//  BIDimmerViewController.m
//  BIDimmerViewController
//
//  Created by 郑林琴 on 15/11/10.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import "BIDimmerViewController.h"

@interface BIDimmerViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL   bi_bePresent;

@end

@implementation BIDimmerViewController


- (instancetype)init{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    self.animateTime = .4f;
    self.containerView = [UIView new];
    self.bi_bePresent = YES;
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.containerView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat containerHeight = CGRectGetHeight(self.containerView.frame);
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), containerHeight);
    
    [UIView animateWithDuration:self.animateTime animations:^{
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - containerHeight, CGRectGetWidth(self.view.bounds), containerHeight);
        self.containerView.frame = frame;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CGFloat containerHeight = CGRectGetHeight(self.containerView.frame);
    
    [UIView animateWithDuration:self.animateTime/2.f animations:^{
        
        self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), containerHeight);
        
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.containerView.frame, location)) {
        [self dismissAlertCompletion:nil];
    }
}




static NSMutableArray *shareViewArr = nil;

- (void)dismissAlertCompletion:(void(^)())competion{
    
    if (self.bi_bePresent) {
        [self dismissViewControllerAnimated:YES completion:competion];
    }else{
        
        CGFloat containerHeight = CGRectGetHeight(self.containerView.frame);
        
        [UIView animateWithDuration:self.animateTime/2.f animations:^{
            
            self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), containerHeight);
            
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [shareViewArr removeObject:self];
        }];
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)showFromView:(UIView *)view{
    self.bi_bePresent = NO;
    if (shareViewArr == nil) {
        shareViewArr = [NSMutableArray new];
    }
    [shareViewArr addObject:self];
    [view addSubview:self.view];
}


@end
