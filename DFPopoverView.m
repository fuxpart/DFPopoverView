//
//  DFPopoverView.m
//  DFPopoverView
//
//  Created by fuxp on 16/6/7.
//  Copyright © 2016年 fuxp. All rights reserved.
//

#import "DFPopoverView.h"

static inline CGFloat screenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

static inline CGFloat screenHeight() {
    return [UIScreen mainScreen].bounds.size.height;
}

#define kArrowSize  10  //箭头高度(如果有的话)
#define kDefaultItemSize    CGSizeMake(120, 44)
#define kSpace 2    //弹框与目标区域的间隔以及弹框与屏幕边缘的最小距离

///显示位置
typedef NS_ENUM(NSInteger, DFPopoverViewLocationType)
{
    ///显示于目标区域左边
    DFPopoverViewLocationTypeLeft,
    ///显示于目标区域右边
    DFPopoverViewLocationTypeRight,
    ///显示于目标区域上边
    DFPopoverViewLocationTypeAbove,
    ///显示于目标区域下边
    DFPopoverViewLocationTypeBelow,
    ///显示不下了
    DFPopoverViewLocationTypeNone
};

@implementation DFPopoverViewItem
{
    @package
    NSString *_title;
    UIImage *_image;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        _title = title;
        _image = image;
    }
    return self;
}

@end

@interface DFPopoverBackgroundView : UIView
@property (nonatomic, assign) DFPopoverViewLocationType locationType;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, strong) UIColor *fillColor;
@end

@implementation DFPopoverBackgroundView
{
    DFPopoverViewType _type;
}

- (instancetype)initWithFrame:(CGRect)frame type:(DFPopoverViewType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        if (DFPopoverViewTypeWithArrow == type)
        {
            self.backgroundColor = [UIColor clearColor];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        _fillColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 0.8;
    }
    return self;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    if (DFPopoverViewTypeWithArrow == _type)
    {
        [self setNeedsDisplay];
    }
    else
    {
        self.backgroundColor = fillColor;
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    _anchorPoint = anchorPoint;
    CGRect frame = self.frame;
    switch (_locationType)
    {
        case DFPopoverViewLocationTypeAbove:
            self.layer.anchorPoint = CGPointMake(anchorPoint.x / self.bounds.size.width, 1);
            break;
        case DFPopoverViewLocationTypeBelow:
            self.layer.anchorPoint = CGPointMake(anchorPoint.x / self.bounds.size.width, 0);
            break;
        case DFPopoverViewLocationTypeLeft:
            self.layer.anchorPoint = CGPointMake(1, anchorPoint.y / self.bounds.size.height);
            break;
        case DFPopoverViewLocationTypeRight:
            self.layer.anchorPoint = CGPointMake(0, anchorPoint.y / self.bounds.size.height);
            break;
        default:
            break;
    }
    self.frame = frame;
}

- (void)drawRect:(CGRect)rect
{
    if (DFPopoverViewTypeWithArrow != _type)
    {
        self.layer.shadowPath = CGPathCreateWithRect(rect, NULL);
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGFloat cornerRadius = 10;
    switch (_locationType)
    {
        case DFPopoverViewLocationTypeAbove:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect) - kArrowSize) cornerRadius:cornerRadius];
            CGPathAddPath(cgPath, NULL, path.CGPath);
            CGPathMoveToPoint(cgPath, NULL, _anchorPoint.x - kArrowSize, CGRectGetMaxY(rect) - kArrowSize);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x, _anchorPoint.y);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x + kArrowSize, CGRectGetMaxY(rect) - kArrowSize);
        }
            break;
        case DFPopoverViewLocationTypeBelow:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + kArrowSize, CGRectGetWidth(rect), CGRectGetHeight(rect) - kArrowSize) cornerRadius:cornerRadius];
            CGPathAddPath(cgPath, NULL, path.CGPath);
            CGPathMoveToPoint(cgPath, NULL, _anchorPoint.x - kArrowSize, CGRectGetMinY(rect) + kArrowSize);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x, _anchorPoint.y);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x + kArrowSize, CGRectGetMinY(rect) + kArrowSize);
        }
            break;
        case DFPopoverViewLocationTypeLeft:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect) - kArrowSize, CGRectGetHeight(rect)) cornerRadius:cornerRadius];
            CGPathAddPath(cgPath, NULL, path.CGPath);
            CGPathMoveToPoint(cgPath, NULL, _anchorPoint.x - kArrowSize, _anchorPoint.y - kArrowSize);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x, _anchorPoint.y);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x - kArrowSize, _anchorPoint.y + kArrowSize);
        }
            break;
        case DFPopoverViewLocationTypeRight:
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(rect) + kArrowSize, CGRectGetMinY(rect), CGRectGetWidth(rect) - kArrowSize, CGRectGetHeight(rect)) cornerRadius:cornerRadius];
            CGPathAddPath(cgPath, NULL, path.CGPath);
            CGPathMoveToPoint(cgPath, NULL, _anchorPoint.x + kArrowSize, _anchorPoint.y - kArrowSize);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x, _anchorPoint.y);
            CGPathAddLineToPoint(cgPath, NULL, _anchorPoint.x + kArrowSize, _anchorPoint.y + kArrowSize);
        }
            break;
        default:
            break;
    }
    self.layer.shadowPath = cgPath;
    CGPathCloseSubpath(cgPath);
    CGContextAddPath(context, cgPath);
    CGContextDrawPath(context, kCGPathEOFill);
}

@end

@interface DFPopoverView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@end

@implementation DFPopoverView
{
    NSArray *_items;
    DFPopoverViewType _type;
    DFPopoverBackgroundView *_backgroundView;
    UIColor *_popFillColor;
}

- (instancetype)initWithItems:(NSArray <DFPopoverViewItem *>*)items type:(DFPopoverViewType)type
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        _items = items;
        _type = type;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (DFPopoverViewItem *)itemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _items.count)
    {
        return nil;
    }
    return _items[index];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DFPopoverViewTableViewCellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
        if ([_popoverViewDelegate respondsToSelector:@selector(separatorInsetForPopoverView:)])
        {
            cell.separatorInset = [_popoverViewDelegate separatorInsetForPopoverView:self];
        }
        else
        {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        if ([_popoverViewDelegate respondsToSelector:@selector(textColorForPopoverView:)])
        {
            cell.textLabel.textColor = [_popoverViewDelegate textColorForPopoverView:self];
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:80.0 / 255.0 green:80.0 / 255.0 blue:80.0 / 255.0 alpha:1];
        }
        if ([_popoverViewDelegate respondsToSelector:@selector(textFontForPopoverView:)])
        {
            cell.textLabel.font = [_popoverViewDelegate textFontForPopoverView:self];
        }
        else
        {
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    DFPopoverViewItem *item = _items[indexPath.row];
    cell.imageView.image = item->_image;
    cell.textLabel.text = item->_title;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_popoverViewDelegate respondsToSelector:@selector(popoverView:didSelectedItemAtIndex:)])
    {
        [_popoverViewDelegate popoverView:self didSelectedItemAtIndex:indexPath.row];
    }
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(_backgroundView.frame, point))
    {
        return NO;
    }
    return YES;
}

#pragma mark - 重写父类方法，防止修改
- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    if (_backgroundView)
    {
        _backgroundView.fillColor = backgroundColor;
    }
    else
    {
        _popFillColor = backgroundColor;
    }
}

#pragma mark - show
- (void)showPopoverFromBarButtonItem:(UIBarButtonItem *)item
{
    UIView *view = [item valueForKey:@"view"];
    [self showPopoverFromView:view];
}

- (void)showPopoverFromView:(UIView *)view
{
    if (!_backgroundView)
    {
        [self createContentForView:view];
    }
    _backgroundView.alpha = 1;
    _backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backgroundView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)createContentForView:(UIView *)view
{
    CGSize itemSize = kDefaultItemSize;
    if ([_popoverViewDelegate respondsToSelector:@selector(itemSizeForPopoverView:)])
    {
        itemSize = [_popoverViewDelegate itemSizeForPopoverView:self];
        if (itemSize.width > screenWidth() - 40)
        {
            itemSize.width = screenWidth() - 40;
        }
        else if (itemSize.width < 0)
        {
            itemSize.width = 0;
        }
        if (itemSize.height > 100)
        {
            itemSize.height = 100;
        }
        else if (itemSize.height < 0)
        {
            itemSize.height = 0;
        }
    }
    CGRect frame = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
    CGSize tableSize = CGSizeMake(itemSize.width, _items.count * itemSize.height);
    CGFloat arrowSize = 0;
    if (DFPopoverViewTypeWithArrow == _type)
    {
        arrowSize = kArrowSize;
    }
    ///箭头方向按上、下、左、右的顺序依次判断。
    DFPopoverViewLocationType location = DFPopoverViewLocationTypeNone;
    if (CGRectGetMaxY(frame) + kSpace + arrowSize + tableSize.height + kSpace <= screenHeight())
    {//箭头朝上，弹框显示在目标view的下方
        location = DFPopoverViewLocationTypeBelow;
    }
    else if (frame.origin.y - kSpace - arrowSize - tableSize.height - kSpace >= 0)
    {//箭头朝下，弹框显示在目标view的上方
        location = DFPopoverViewLocationTypeAbove;
    }
    else if (CGRectGetMaxX(frame) + kSpace + arrowSize + tableSize.width + kSpace <= screenWidth())
    {//箭头朝左，弹框显示在目标view的右边
        location = DFPopoverViewLocationTypeRight;
    }
    else if (frame.origin.x - kSpace - arrowSize - tableSize.width - kSpace >= 0)
    {//箭头朝右，弹框显示在目标view的左边
        location = DFPopoverViewLocationTypeLeft;
    }
    else
    {//显示不下了。
        return;
    }
    CGRect backgroundFrame, tableFrame;     //background view的frame和table view的frame
    CGFloat anchorPointX, anchorPointY;   //箭头的x坐标和y坐标
    if (DFPopoverViewLocationTypeAbove == location || DFPopoverViewLocationTypeBelow == location)
    {//上下
        CGFloat mid = CGRectGetMidX(frame);
        //弹框的x坐标
        CGFloat x = mid - tableSize.width / 2;
        if (x < kSpace)
        {//如果箭头居中，则左侧超出屏幕范围，需要调整
            x = kSpace;
            anchorPointX = mid - kSpace;
        }
        else if (x + tableSize.width + kSpace > screenWidth())
        {//如果箭头居中，则右侧超出屏幕范围，需要调整
            x = screenWidth() - tableSize.width - kSpace;
            anchorPointX = mid - x;
        }
        else
        {//弹框显示位置正常，箭头居中。
            anchorPointX = tableSize.width / 2;
        }
        if (DFPopoverViewLocationTypeBelow == location)
        {
            backgroundFrame = CGRectMake(x, CGRectGetMaxY(frame) + kSpace, tableSize.width, arrowSize + tableSize.height);
            tableFrame = CGRectMake(0, arrowSize, tableSize.width, tableSize.height - 1);   //高度-1是为了不显示最后一条分割线
            anchorPointY = 0;
        }
        else
        {
            backgroundFrame = CGRectMake(x, frame.origin.y - kSpace - arrowSize - tableSize.height, tableSize.width, arrowSize + tableSize.height);
            tableFrame = CGRectMake(0, 0, tableSize.width, tableSize.height - 1);   //高度-1是为了不显示最后一条分割线
            anchorPointY = CGRectGetHeight(backgroundFrame);
        }
    }
    else if (DFPopoverViewLocationTypeLeft == location || DFPopoverViewLocationTypeRight == location)
    {//左右
        CGFloat mid = CGRectGetMidY(frame);
        //弹框的y坐标
        CGFloat y = mid - tableSize.height / 2;
        if (y < kSpace)
        {//如果箭头居中，则上边超出屏幕范围，需要调整
            y = kSpace;
            anchorPointY = mid - kSpace;
        }
        else if (y + tableSize.height + kSpace > screenHeight())
        {//如果箭头居中，则下边超出屏幕范围，需要调整
            y = screenHeight() - tableSize.height - kSpace;
            anchorPointY = mid - y;
        }
        else
        {//弹框显示位置正常，箭头居中。
            anchorPointY = tableSize.height / 2;
        }
        if (DFPopoverViewLocationTypeLeft == location)
        {
            backgroundFrame = CGRectMake(CGRectGetMinX(frame) - kSpace - tableSize.width - arrowSize, y, tableSize.width + arrowSize, tableSize.height);
            tableFrame = CGRectMake(0, 0, tableSize.width, tableSize.height - 1);   //高度-1是为了不显示最后一条分割线
            anchorPointX = CGRectGetWidth(backgroundFrame);
        }
        else
        {
            backgroundFrame = CGRectMake(CGRectGetMaxX(frame) + kSpace, y, tableSize.width + arrowSize, tableSize.height);
            tableFrame = CGRectMake(arrowSize, 0, tableSize.width, tableSize.height - 1);   //高度-1是为了不显示最后一条分割线
            anchorPointX = 0;
        }
    }
    _backgroundView = [[DFPopoverBackgroundView alloc]initWithFrame:backgroundFrame type:_type];
    _backgroundView.locationType = location;
    _backgroundView.anchorPoint = CGPointMake(anchorPointX, anchorPointY);
    [self addSubview:_backgroundView];
    
    if (_popFillColor)
    {
        _backgroundView.fillColor = _popFillColor;
        _popFillColor = nil;
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.rowHeight = itemSize.height;
    tableView.scrollEnabled = NO;
    if ([_popoverViewDelegate respondsToSelector:@selector(separatorColorForPopoverView:)])
    {
        tableView.separatorColor = [_popoverViewDelegate separatorColorForPopoverView:self];
    }
    tableView.backgroundColor = [UIColor clearColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    tableView.dataSource = self;
    tableView.delegate = self;
    [_backgroundView addSubview:tableView];
}

#pragma mark - dismiss
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        _backgroundView.alpha = 0;
        _backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
