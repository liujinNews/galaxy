//
//  STPickerCategory.m
//  galaxy
//
//  Created by hfk on 2016/11/30.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "STPickerCategory.h"
@interface STPickerCategory()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.大类数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayFirstCate;
/** 3.当前小类数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySecondCate;
/** 5.当前选中Model */
@property (nonatomic, strong, nullable)CostCateNewSubModel *selectModel;
@end
@implementation STPickerCategory

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
#pragma mark - ---视图更新 ---
- (void)UpdatePickUI
{
    _firstindex=0;
    _secondindex=0;
    // 1.获取数据
    self.arrayFirstCate=[NSMutableArray arrayWithArray:self.arrayRoot];
    for (NSInteger i=0; i<self.arrayFirstCate.count; i++) {
        CostCateNewModel *firstmodel=self.arrayFirstCate[i];
        NSArray *array=[[NSArray alloc]initWithArray:firstmodel.getExpTypeList];
        for (NSInteger j=0; j<array.count; j++) {
            CostCateNewSubModel *model=array[j];
            if ([[NSString stringWithFormat:@"%@",model.expenseCode] isEqualToString:[NSString stringWithFormat:@"%@",_CateModel.expenseCode]]) {
                _firstindex=i;
                _secondindex=j;
                break;
            }
        }
    }
    CostCateNewModel *model=self.arrayFirstCate[_firstindex];
    [self.arraySecondCate addObjectsFromArray:model.getExpTypeList];
    _selectModel=self.arraySecondCate[_secondindex];
    // 2.设置视图的默认属性
    _heightPickerComponent = 45;
    [self setTitle:self.typeTitle];
    self.pickerView.delegate=self;
    self.pickerView .dataSource=self;
    [self.pickerView selectRow: _firstindex inComponent:0 animated:NO];
    [self.pickerView selectRow: _secondindex inComponent:1 animated:NO];

    
    CGFloat rightW = 50;
    CGFloat rightH = STControlSystemHeight;
    CGFloat rightX = self.contentView.stwidth-45-50;
    CGFloat rightY = 0 ;
    UIButton *buttonRight=[GPUtils createButton:CGRectMake(rightX, rightY, rightW, rightH) action:@selector(selectedSearch) delegate:self normalImage:[UIImage imageNamed:@"NavBarImg_Search"] highlightedImage:[UIImage imageNamed:@"NavBarImg_Search"]];
    [self.contentView addSubview:buttonRight];
    
}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.arrayFirstCate.count;
    }else{
        return self.arraySecondCate.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return self.heightPickerComponent;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [self changeSpearatorLineColor];
    NSString *text;
    if (component == 0) {
        CostCateNewModel *model=self.arrayFirstCate[row];
        text =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.expenseType]]?[NSString stringWithFormat:@"%@",model.expenseType]:@"";
        CGSize size = [NSString sizeWithText:text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, 45)];
        UILabel *label = [[UILabel alloc]init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:Font_Important_15_20];
        [label setText:text];
        if (size.width>Main_Screen_Width/2) {
            label.font = Font_Same_10_20;
            label.numberOfLines = 0;
        }
        return label;
    }else{
        CostCateNewSubModel *model=self.arraySecondCate[row];
        text =[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.expenseType]]?[NSString stringWithFormat:@"%@",model.expenseType]:@"";
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width/2, 45)];
        UIImageView *imageView=[GPUtils createImageViewFrame:CGRectMake(0, 0, 32, 32) imageName:[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.expenseIcon]]?[NSString stringWithFormat:@"%@",model.expenseIcon]:@"15"];
        imageView.center=CGPointMake(21, 22.5);
        [view addSubview:imageView];
        CGSize size = [NSString sizeWithText:text font:Font_Important_15_20 maxSize:CGSizeMake(MAXFLOAT, 45)];
        UILabel *label = [GPUtils createLable:CGRectMake(54, 0, Main_Screen_Width/2-56, 45) text:text font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        if (size.width>Main_Screen_Width/2-56) {
            label.font = Font_Same_10_20;
            label.numberOfLines = 0;
        }
        [view addSubview:label];
        return view;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (_firstindex!=row) {
            _firstindex=row;
            [self.arraySecondCate removeAllObjects];
            CostCateNewModel *model=self.arrayFirstCate[_firstindex];
            [self.arraySecondCate addObjectsFromArray:model.getExpTypeList];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            _selectModel=self.arraySecondCate[0];
        }
    }else if (component == 1) {
        _secondindex=row;
        _selectModel=self.arraySecondCate[row];
    }
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk{
    if (self.ChooseCateBlock) {
        self.ChooseCateBlock(_arrayFirstCate[_firstindex], _selectModel);
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

- (NSMutableArray *)arrayFirstCate
{
    if (!_arrayFirstCate) {
        _arrayFirstCate = [NSMutableArray array];
    }
    return _arrayFirstCate;
}

- (NSMutableArray *)arraySecondCate
{
    if (!_arraySecondCate) {
        _arraySecondCate = [NSMutableArray array];
    }
    return _arraySecondCate;
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
-(void)selectedSearch{
    
    ExpenseCodeListViewController *ex = [[ExpenseCodeListViewController alloc]init];
    ex.arr_DataList =self.DateSourceArray;
    ex.str_CateLevel = @"2";
    ex.str_flowCode=self.str_flowCode;
    ex.ChooseCateBlock = self.ChooseCateBlock;
    [[AppDelegate appDelegate].topViewController.navigationController pushViewController:ex animated:YES];
    [super selectedOk];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
