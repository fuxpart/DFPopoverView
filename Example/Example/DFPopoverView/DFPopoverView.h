//
//  DFPopoverView.h
//  DFPopoverView
//
//  Created by fuxp on 16/6/7.
//  Copyright © 2016年 fuxp. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 popover view的样式
 */
typedef NS_ENUM(NSInteger, DFPopoverViewType) {
    /*!
     常规样式，一个矩形框
     */
    DFPopoverViewTypeNormal,
    /*!
     带箭头，四周有圆角
     */
    DFPopoverViewTypeWithArrow
};

@protocol DFPopoverViewDelegate;
/*!
 这个类关联popover view中每一行的一个对象
 */
@interface DFPopoverViewItem : NSObject
/*!
 创建并返回一个`DFPopoverViewItem`的实例
 
 @param title 需要在popover view中显示的文字内容
 @param image 需要在popover view中显示的图片
 
 @return 一个`DFPopoverViewItem`的实例
 */
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

/*!
 这个类用来在屏幕上显示一个浮动菜单。
 */
@interface DFPopoverView : UIView
/*!
 创建并返回一个`DFPopoverView`对象
 
 @param items 用于存放菜单选项的数组，不可为空。
 @param type  外观样式。
 
 @return 一个`DFPopoverView`的实例
 */
- (instancetype)initWithItems:(NSArray <DFPopoverViewItem *>*)items type:(DFPopoverViewType)type;
/*!
 代理，处理菜单点击事件，以及修改菜单外观。
 */
@property (nonatomic, weak) id<DFPopoverViewDelegate> popoverViewDelegate;
/*!
 从目标控件那里显示菜单。popover view的位置会根据该控件的尺寸与位置自动调整。菜单在点击空白区域或者选择了任意选项后会自动消失。
 
 @param view 需要显示popover view的控件
 */
- (void)showPopoverFromView:(UIView *)view;
/*!
 从bar button item那里显示popover view。popover view的位置会根据该控件的尺寸与位置自动调整。菜单在点击空白区域或者选择了任意选项后会自动消失。
 
 @param item 需要显示popover view的bar button item
 */
- (void)showPopoverFromBarButtonItem:(UIBarButtonItem *)item;

- (DFPopoverViewItem *)itemAtIndex:(NSInteger)index;

@end


@protocol DFPopoverViewDelegate <NSObject>

@required
/*!
 点击popover view中某个选项后的回调
 
 @param popoverView 选项所在的popover view
 @param index       点击的选项所在的序号
 */
- (void)popoverView:(DFPopoverView *)popoverView didSelectedItemAtIndex:(NSInteger)index;

@optional
/*!
 通过这个函数修改选项文字的颜色。默认为red:80，green:80，blue:80
 
 @param popoverView 需要修改文字颜色的popover view
 
 @return 新的文字颜色
 */
- (UIColor *)textColorForPopoverView:(DFPopoverView *)popoverView;
/*!
 通过这个函数修改选项文字的字体。默认为系统14号字体
 
 @param popoverView 需要修改文字字体的popover view
 
 @return 新的字体
 */
- (UIFont *)textFontForPopoverView:(DFPopoverView *)popoverView;
/*!
 通过这个函数修改每个选项显示的大小。不可设置的过大或者过小，否则可能无法正常显示。默认为{120，44}
 
 @param popoverView 需要调整选项显示大小的popover view
 
 @return 新的选项尺寸
 */
- (CGSize)itemSizeForPopoverView:(DFPopoverView *)popoverView;
/*!
 通过这个函数可以修改选项之间分割线的颜色。默认为灰色
 
 @param popoverView 需要设置分割线颜色的popover view
 
 @return 新的分割线颜色
 */
- (UIColor *)separatorColorForPopoverView:(DFPopoverView *)popoverView;
/*!
 通过这个函数可以修改分割线的偏移。默认为{0,15,0,15}
 
 @param popoverView 需要设置分割线偏移的popover view
 
 @return 新的分割线偏移
 */
- (UIEdgeInsets)separatorInsetForPopoverView:(DFPopoverView *)popoverView;

@end
