//
//  ViewController.m
//  Example
//
//  Created by Fuxp on 2017/3/25.
//  Copyright © 2017年 Fuxp. All rights reserved.
//

#import "ViewController.h"
#import "DFPopoverView.h"

@interface ViewController ()<DFPopoverViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)show:(id)sender {
    DFPopoverViewItem *item1 = [[DFPopoverViewItem alloc]initWithTitle:@"创建群聊" image:nil];
    DFPopoverViewItem *item2 = [[DFPopoverViewItem alloc]initWithTitle:@"加好友/群" image:nil];
    DFPopoverViewItem *item3 = [[DFPopoverViewItem alloc]initWithTitle:@"扫一扫" image:nil];
    DFPopoverViewItem *item4 = [[DFPopoverViewItem alloc]initWithTitle:@"面对面快传" image:nil];
    DFPopoverViewItem *item5 = [[DFPopoverViewItem alloc]initWithTitle:@"付款" image:nil];
    DFPopoverViewItem *item6 = [[DFPopoverViewItem alloc]initWithTitle:@"拍摄" image:nil];
    DFPopoverViewItem *item7 = [[DFPopoverViewItem alloc]initWithTitle:@"面对面红包" image:nil];
    DFPopoverView *pop = [[DFPopoverView alloc]initWithItems:@[item1, item2, item3, item4, item5, item6, item7] type:DFPopoverViewTypeWithArrow];
    pop.popoverViewDelegate = self;
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [pop showPopoverFromBarButtonItem:sender];
    } else {
        [pop showPopoverFromView:sender];
    }
}

- (void)popoverView:(DFPopoverView *)popoverView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%zi", index);
}

- (CGSize)itemSizeForPopoverView:(DFPopoverView *)popoverView {
    return CGSizeMake(120, 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
