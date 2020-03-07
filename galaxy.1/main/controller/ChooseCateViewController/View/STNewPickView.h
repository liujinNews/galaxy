//
//  STNewPickView.h
//  galaxy
//
//  Created by hfk on 2018/1/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "STPickerView.h"
#import "STNewPickModel.h"

typedef void(^STNewPickerBlock)(STNewPickModel *firstModel,STNewPickSubModel *secondModel,NSInteger type);

@class STNewPickView;

@interface STNewPickView : STPickerView

/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property (nonatomic,strong)NSMutableArray *DateSourceArray;
@property (nonatomic,strong)STNewPickModel  *first_Model;
@property (nonatomic,strong)STNewPickSubModel *second_Model;
@property (nonatomic,assign)NSInteger firstindex;
@property (nonatomic,assign)NSInteger secondindex;
@property (nonatomic,copy)NSString *typeTitle;
@property (nonatomic,assign)NSInteger int_compRows;//几组
@property (nonatomic,assign)NSInteger type;
@property (nonatomic, copy) STNewPickerBlock block;

-(void)UpdatePickUI;

@end
