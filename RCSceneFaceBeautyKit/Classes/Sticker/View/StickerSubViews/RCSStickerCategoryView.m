//
//  RCSStickerCategoryView.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSStickerCategoryView.h"

@interface RCSStickerCategoryView ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *sqLine;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *sqVerticalLine;
@property (nonatomic, strong) NSArray<UIButton *> *categoryBtns;
@property (nonatomic, strong) UIButton *currentBtn;

@end

static NSInteger kSelectedStickerCategoryViewTagMask = 4321;

@implementation RCSStickerCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {

    [self addSubview:self.sqLine];
    [self.sqLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.offset(0);
        make.height.offset(0.5);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.width.height.offset(20);
    }];
    
    [self addSubview:self.sqVerticalLine];
    [self.sqVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.mas_equalTo(self.cancelBtn.mas_trailing).offset(20);
        make.width.offset(0.5);
        make.height.offset(20);
    }];
    
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.offset(0);
        make.leading.mas_equalTo(self.sqVerticalLine.mas_trailing).offset(20);
        make.trailing.inset(20);
    }];
    
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    if (titles.count == 0) {
        return ;
    }
    
    [self.stackView removeAllSubviews];
    
    NSMutableArray *btns = [NSMutableArray new];
    for (int i = 0; i < titles.count; i++) {
        UIButton *categoryBtn = [self createCategoryButtonWithTitle:titles[i]];
        categoryBtn.tag = kSelectedStickerCategoryViewTagMask + i;

        [self.stackView addArrangedSubview:categoryBtn];
        [btns addObject:categoryBtn];
    }
    self.categoryBtns = [NSArray arrayWithArray:btns];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= self.categoryBtns.count) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    [self categotyBtnClicked:self.categoryBtns[selectedIndex]];
}

- (UIButton *)createCategoryButtonWithTitle:(NSString *)title {
    UIButton *categotyBtn = [UIButton new];
    categotyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];

    [categotyBtn setTitle:title forState:UIControlStateNormal];
    [categotyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [categotyBtn setTitleColor:RCSBeautyMainColor forState:UIControlStateSelected];
    
    [categotyBtn addTarget:self
                    action:@selector(categotyBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [categotyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];

    return categotyBtn;
}

- (void)categotyBtnClicked:(UIButton *)btn {
    self.currentBtn.selected = NO;
    
    btn.selected = !btn.isSelected;
    self.currentBtn = btn;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(toggleCategoryIndex:)]) {
        [self.delegate toggleCategoryIndex:btn.tag - kSelectedStickerCategoryViewTagMask];
        _selectedIndex = btn.tag - kSelectedStickerCategoryViewTagMask;
    }
}

- (void)cancelBtnClicked {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSticker)]) {
        [self.delegate cancelSticker];
    }
}

#pragma mark - lazy load
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _stackView;
}

- (UIView *)sqLine {
    if (!_sqLine) {
        _sqLine = [UIView new];
        _sqLine.backgroundColor = [UIColor lightGrayColor];
        _sqLine.alpha = 0.2;
    }
    return _sqLine;
}

- (UIView *)sqVerticalLine {
    if (!_sqVerticalLine) {
        _sqVerticalLine = [UIView new];
        _sqVerticalLine.backgroundColor = [UIColor lightGrayColor];
        _sqVerticalLine.alpha = 0.2;
    }
    return _sqVerticalLine;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:RCSBeautyImageNamed(@"sticker_cancel") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
