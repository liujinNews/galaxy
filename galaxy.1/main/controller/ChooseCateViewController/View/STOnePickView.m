//
//  STOnePickView.m
//  galaxy
//
//  Created by hfk on 2017/5/26.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "STOnePickView.h"
@interface STOnePickView()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 5.当前选中Model */
@property (nonatomic, strong, nullable)STOnePickModel *selectModel;
@end
@implementation STOnePickView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
#pragma mark - ---视图更新 ---
- (void)UpdatePickUI
{
    
    _index=0;
    // 1.获取数据
    for (NSInteger i=0; i<self.arrayRoot.count; i++) {
        STOnePickModel *model=self.arrayRoot[i];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.Id]]) {
            if ([[NSString stringWithFormat:@"%@",model.Id] isEqualToString:[NSString stringWithFormat:@"%@",_Model.Id]]) {
                _index=i;
                break;
            }
        }else{
            if ([[NSString stringWithFormat:@"%@",model.Type] isEqualToString:[NSString stringWithFormat:@"%@",_Model.Type]]) {
                _index=i;
                break;
            }
        }
    }
    if (self.arrayRoot.count==0) {
        return;
    }
    _selectModel=self.arrayRoot[_index];
    // 2.设置视图的默认属性
    _heightPickerComponent = 45;
    [self setTitle:self.typeTitle];
    self.pickerView.delegate=self;
    self.pickerView .dataSource=self;
    [self.pickerView selectRow: _index inComponent:0 animated:NO];
    
}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayRoot.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    [self changeSpearatorLineColor];
    STOnePickModel *model=self.arrayRoot[row];
    NSString *text =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.Type]]?[NSString stringWithFormat:@"%@",model.Type]:@"";
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:Font_filterTitle_17];
    [label setText:text];
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _index=row;
    _selectModel=self.arrayRoot[row];
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk{
    if (self.block) {
        self.block(_selectModel,_type);
    }
    [super selectedOk];
}

#pragma mark - --- getters 属性 ---

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        _arrayRoot = [[NSArray alloc]initWithArray:self.DateSourceArray];
    }
    return _arrayRoot;
}
#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1){
            speartorView.backgroundColor =Color_GrayLight_Same_20;//隐藏分割线
        }
    }
}

@end
