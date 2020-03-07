//
//  STOnePickView.h
//  galaxy
//
//  Created by hfk on 2017/5/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "STPickerView.h"
#import <UIKit/UIKit.h>
#import "STPickerView.h"
#import "STOnePickModel.h"

typedef void(^STOnePickerBlock)(STOnePickModel *Model,NSInteger type);

@class STOnePickView;

@interface STOnePickView : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property (nonatomic,strong)NSMutableArray *DateSourceArray;
@property (nonatomic,strong)STOnePickModel *Model;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)NSString *typeTitle;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic, copy) STOnePickerBlock block;
-(void)UpdatePickUI;
@end
