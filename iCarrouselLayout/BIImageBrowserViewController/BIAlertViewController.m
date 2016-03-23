//
//  BIAlertViewController.m
//  BIDimmerViewController
//
//  Created by ET|冰琳 on 15/11/10.
//  Copyright © 2015年 ET|冰琳. All rights reserved.
//

#import "BIAlertViewController.h"
#import "UIButton+setStateBackgroundColor.h"


@interface BIAlertAction ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) dispatch_block_t action;

@end
@implementation BIAlertAction

+(instancetype)actionWithTitle:(NSString *)title action:(dispatch_block_t)action{
    BIAlertAction *itemAction = [BIAlertAction new];
    itemAction.title = title;
    itemAction.action = action;
    return itemAction;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end



@interface BIAlertViewController ()

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) CGFloat cancelTopSpacing;


@end


@implementation BIAlertViewController

- (NSMutableArray *)actions{
    if (_actions == nil) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

- (void)addAction:(BIAlertAction *)action{
    [self.actions addObject:action];
}

- (void)loadView{
        NSLog(@"%s",__func__);
    [super loadView];
    self.cancelTopSpacing = 5;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    
    [self.view addSubview:self.containerView];
    
    CGFloat buttonHeight = 44.f;
    
    for (int i = 0 ; i < self.actions.count ; i ++ ) {
        
        BIAlertAction *action = self.actions[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.9] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9] forState:UIControlStateNormal];
        [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.85] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(0, i * buttonHeight + ((i == self.actions.count - 1) ? (self.cancelTopSpacing + 0.5) :0), self.view.frame.size.width, buttonHeight - 0.5f);
        [self.containerView addSubview:button];
        
    }
    CGFloat heightContainer = self.actions.count * buttonHeight + self.cancelTopSpacing;
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - heightContainer, CGRectGetWidth(self.view.frame), heightContainer);
}

- (void)itemAction:(UIButton *)button{
    BIAlertAction *actionObj = self.actions[button.tag - 100];
     NSLog(@"before dismiss%f",CFAbsoluteTimeGetCurrent());
    
    [self dismissAlertCompletion:^{
        NSLog(@"dismiss completion %f",CFAbsoluteTimeGetCurrent());
    }];
     NSLog(@"after dismiss %f",CFAbsoluteTimeGetCurrent());
    if (actionObj.action) {
        actionObj.action();
    }
     NSLog(@"execution action%f",CFAbsoluteTimeGetCurrent());
}


- (void)longPressed:(UILongPressGestureRecognizer *)press{
    
    if (press.state == UIGestureRecognizerStateEnded) {
        
        BIAlertViewController *alert = [[BIAlertViewController alloc] init];
        alert.containerView.backgroundColor = [UIColor redColor];
        
        [[[[UIApplication sharedApplication].delegate window] rootViewController] presentViewController:alert animated:YES completion:nil];
    }
}

@end
