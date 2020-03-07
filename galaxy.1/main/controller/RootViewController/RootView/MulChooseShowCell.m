//
//  MulChooseShowCell.m
//  galaxy
//
//  Created by hfk on 2018/8/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MulChooseShowCell.h"

@implementation MulChooseShowCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self createView];
    }
    return self;
}
-(void)createView{
    
    if (!_lab_title) {
        _lab_title=[GPUtils createLable:CGRectMake(0, 0, XBHelper_Title_Width, 50) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_title.numberOfLines=0;
        [self.contentView addSubview:_lab_title];
    }
    [_lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(@12);
        make.width.equalTo(XBHelper_Title_Width);
    }];
    
    if (!_img_select) {
        _img_select = [GPUtils createImageViewFrame:CGRectZero imageName:@"skipImage"];
        [self.contentView addSubview:_img_select];
    }
    [_img_select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(@15);
        make.right.equalTo(self.contentView.mas_right).offset(@-12);
        make.size.equalTo(CGSizeMake(20, 20));
    }];

    if (!_txf_content) {
        _txf_content = [GPUtils createTextField:CGRectZero placeholder:nil delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20];
        _txf_content.userInteractionEnabled = NO;
        [self.contentView addSubview:_txf_content];
    }
    [_txf_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.lab_title.mas_right).offset(@15);
        make.right.equalTo(self.img_select.left);
    }];
}

-(void)configCellWithModel:(MyProcurementModel *)model WithValue:(NSString *)value WithIndex:(NSIndexPath *)index withStatus:(NSInteger)status{
    
    [_img_select mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    _img_select.hidden = YES;
    
    if (index.row == 0) {
        self.lab_title.text = [NSString stringWithIdOnNO:model.Description];
        if (status == 1) {
            [_img_select mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(20, 20));
            }];
            _img_select.hidden = NO;
            if ([NSString isEqualToNull:model.tips]){
                if ([model.isRequired floatValue]==1) {
                    self.txf_content .placeholder=[NSString stringWithFormat:@"%@%@",model.tips,Custing(@"(必选)", nil)] ;
                }else{
                    self.txf_content .placeholder=model.tips;
                }
            }else{
                if ([model.isRequired floatValue]==1) {
                    self.txf_content .placeholder=Custing(@"(必选)", nil);
                }
            }
        }
        [_txf_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
        }];
    }else{
        [_txf_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(@-11);
        }];
    }
    _txf_content.text = [NSString stringWithIdOnNO:value];
    if (status == 1) {
        _txf_content.textColor = Color_form_TextField_20;
    }else{
        _txf_content.textColor = Color_Blue_Important_20;
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
