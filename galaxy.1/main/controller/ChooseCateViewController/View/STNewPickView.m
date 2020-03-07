//
//  STNewPickView.m
//  galaxy
//
//  Created by hfk on 2018/1/25.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "STNewPickView.h"

@interface STNewPickView()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.大类数组 */
@property (nonatomic, strong, nullable)NSMutableArray *array_First;
/** 3.当前小类数组 */
@property (nonatomic, strong, nullable)NSMutableArray *array_Second;
/** 5.当前选中Model */
@property (nonatomic, strong, nullable)STNewPickSubModel *second_selectModel;

@end

@implementation STNewPickView
#pragma mark - ---视图更新 ---
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)UpdatePickUI{
    _firstindex=0;
    _secondindex=0;
    if (self.int_compRows!=2) {
        self.int_compRows=1;
    }
    // 1.获取数据
    self.array_First=[NSMutableArray arrayWithArray:self.arrayRoot];
    for (NSInteger i=0; i<self.array_First.count; i++) {
        STNewPickModel *firstmodel=self.array_First[i];
        if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",firstmodel.Id]]) {
            if ([[NSString stringWithFormat:@"%@",firstmodel.Id] isEqualToString:[NSString stringWithFormat:@"%@",_first_Model.Id]]) {
                _firstindex=i;
                break;
            }
        }else{
            if ([[NSString stringWithFormat:@"%@",firstmodel.Type] isEqualToString:[NSString stringWithFormat:@"%@",_first_Model.Type]]) {
                _firstindex=i;
                break;
            }
        }
    }
    if (self.int_compRows==2) {
        STNewPickModel *firstmodel=self.array_First[_firstindex];
        [self.array_Second addObjectsFromArray:firstmodel.SubDataArray];
        for (NSInteger i=0; i<self.array_Second.count; i++) {
            STNewPickSubModel *secondmodel=self.array_Second[i];
            if ([NSString isEqualToNull:[NSString stringWithFormat:@"%@",secondmodel.Id]]) {
                if ([[NSString stringWithFormat:@"%@",secondmodel.Id] isEqualToString:[NSString stringWithFormat:@"%@",_second_Model.Id]]) {
                    _secondindex=i;
                    break;
                }
            }else{
                if ([[NSString stringWithFormat:@"%@",secondmodel.Type] isEqualToString:[NSString stringWithFormat:@"%@",_second_Model.Type]]) {
                    _secondindex=i;
                    break;
                }
            }
        }
    }
    // 2.设置视图的默认属性
    _heightPickerComponent = 45;
    [self setTitle:self.typeTitle];
    self.pickerView.delegate=self;
    self.pickerView .dataSource=self;
    [self.pickerView selectRow: _firstindex inComponent:0 animated:NO];
    if (self.int_compRows==2) {
        _second_selectModel=self.array_Second[_secondindex];
        [self.pickerView selectRow: _secondindex inComponent:1 animated:NO];
    }
}
#pragma mark - --- delegate 视图委托 ---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.int_compRows;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.array_First.count;
    }else{
        return self.array_Second.count;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.heightPickerComponent;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [self changeSpearatorLineColor];
    NSString *text;
    if (component == 0) {
        STNewPickModel *model=self.array_First[row];
        text =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.Type]]?[NSString stringWithFormat:@"%@",model.Type]:@"";
        UILabel *label = [[UILabel alloc]init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:Font_Important_15_20];
        [label setText:text];
        return label;
    }else{
        STNewPickSubModel *model=self.array_Second[row];
        text =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.Type]]?[NSString stringWithFormat:@"%@",model.Type]:@"";
        UILabel *label = [[UILabel alloc]init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:Font_Important_15_20];
        [label setText:text];
        return label;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (_firstindex!=row) {
            _firstindex=row;
            if (self.int_compRows==2) {
                [self.array_Second removeAllObjects];
                STNewPickModel *model=self.array_First[_firstindex];
                [self.array_Second addObjectsFromArray:model.SubDataArray];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                _second_selectModel=self.array_Second[0];
            }
        }
    }else if (component == 1) {
        _secondindex=row;
        _second_selectModel=self.array_Second[row];
    }
}
#pragma mark - --- event response 事件相应 ---
- (void)selectedOk{
    if (self.block) {
        self.block(self.array_First[_firstindex], _second_selectModel, _type);
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

- (NSMutableArray *)array_First
{
    if (!_array_First) {
        _array_First = [NSMutableArray array];
    }
    return _array_First;
}

- (NSMutableArray *)array_Second
{
    if (!_array_Second) {
        _array_Second = [NSMutableArray array];
    }
    return _array_Second;
}
#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor{
    for(UIView *speartorView in self.pickerView.subviews){
        if (speartorView.frame.size.height < 1){
            speartorView.backgroundColor =Color_GrayLight_Same_20;//隐藏分割线
        }
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
