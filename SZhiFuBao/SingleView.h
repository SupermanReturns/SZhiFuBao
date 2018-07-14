//
//  SingleView.h
//  SZhiFuBao
//
//  Created by Superman on 2018/7/12.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleViewDelegate <NSObject>

- (void)clickOneViewReturnTitle:(NSString *)title;
- (void)beginMoveAction:(NSString *)tag;//移动前
- (void)moveViewAction:(NSString *)tag gesture:(UILongPressGestureRecognizer *)gesture;//移动中
- (void)endMoveViewAction:(NSString *)tag;//结束移动

@end
@interface SingleView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGPoint viewPoint;
@property (nonatomic, strong) NSString *tagid;

@property (nonatomic, weak) id<SingleViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@end
