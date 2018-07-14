//
//  SingleView.m
//  SZhiFuBao
//
//  Created by Superman on 2018/7/12.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "SingleView.h"

@interface SingleView () {
    UILabel *_label;
}

@end

@implementation SingleView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    if(self=[super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.title = title;
        [self initWithLabel];
    }
    return self;
}
- (void)initWithLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50)];
    label.text = _title;
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
    _label = label;
    
    //长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewLongPressGesture:)];
    [self addGestureRecognizer:longGesture];
    
    //点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewtapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
}

#pragma 长按手势
- (void)viewLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
            //移动前
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(endMoveViewAction:)]) {
                _label.textColor = [UIColor redColor];
                [self.delegate beginMoveAction:self.tagid];
            }
            break;
            //移动中
        case UIGestureRecognizerStateChanged:
            
            if ([self.delegate respondsToSelector:@selector(moveViewAction:gesture:)]) {
                
                [self.delegate moveViewAction:self.tagid gesture:gesture];
            }
            break;
            //移动后
        case UIGestureRecognizerStateEnded:
            
            if ([self.delegate respondsToSelector:@selector(endMoveViewAction:)]) {
                _label.textColor = [UIColor grayColor];
                [self.delegate endMoveViewAction:self.tagid];
            }
            break;
            
        default:
            break;
    }
}

#pragma 轻拍手势
- (void)viewtapGesture:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(clickOneViewReturnTitle:)]) {
        [self.delegate clickOneViewReturnTitle:_title];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
