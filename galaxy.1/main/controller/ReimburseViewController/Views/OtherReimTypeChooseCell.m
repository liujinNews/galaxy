//
//  OtherReimTypeChooseCell.m
//  galaxy
//
//  Created by hfk on 2016/11/29.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "OtherReimTypeChooseCell.h"
#import "OtherReimTypeChooseModel.h"
#import "PerformanceTypeModel.h"
@implementation OtherReimTypeChooseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =Color_form_TextFieldBackgroundColor;
        if (!_titleLabel) {
            _titleLabel=[GPUtils createLable:CGRectMake(0, 0, Main_Screen_Width-60, 25) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
            _titleLabel.center=CGPointMake(Main_Screen_Width/2-15, 25);
            [self.contentView addSubview:_titleLabel];
        }
        if (!_clickImageView) {
            _clickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20, 20)];
            _clickImageView.center=CGPointMake(Main_Screen_Width-25, 25);
            _clickImageView.image =[UIImage imageNamed:@"skipImage"];
            [self.contentView addSubview:_clickImageView];
        }
        
        if (!_LineView) {
            _LineView=[[UIView alloc]initWithFrame:CGRectZero];
            _LineView.backgroundColor=Color_GrayLight_Same_20;
            [self.contentView addSubview:_LineView];
        }
    }
    return self;
}
-(void)configCellWithRows:(NSInteger)row WithResultArray:(NSMutableArray *)array{
    OtherReimTypeChooseModel *model=array[row];
    self.titleLabel.text=[NSString isEqualToNull:[NSString stringWithFormat:@"%@",model.expenseType]]?[NSString stringWithFormat:@"%@",model.expenseType]:@"";
    if (row!=array.count-1) {
        _LineView.frame=CGRectMake(15, 49.5, Main_Screen_Width-15, 0.5);
    }else{
        _LineView.frame=CGRectMake(0, 49.5, Main_Screen_Width, 0.5);
    }
}
-(void)configPerformanceCellWithRows:(NSInteger)row WithResultArray:(NSMutableArray *)array{
    
    PerformanceTypeModel *model=array[row];
    userData *userdatas=[userData shareUserData];
    NSString *title=nil;
    if ([userdatas.language isEqualToString:@"ch"]) {
        title=[model.name isKindOfClass:[NSNull class]]?@"":[NSString stringWithFormat:@"%@",model.name];
    }else{
        title=[model.nameEn isKindOfClass:[NSNull class]]?@"":[NSString stringWithFormat:@"%@",model.nameEn];
    }
    self.titleLabel.text=title;
    if (row!=array.count-1) {
        _LineView.frame=CGRectMake(15, 49.5, Main_Screen_Width-15, 0.5);
    }else{
        _LineView.frame=CGRectMake(0, 49.5, Main_Screen_Width, 0.5);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
