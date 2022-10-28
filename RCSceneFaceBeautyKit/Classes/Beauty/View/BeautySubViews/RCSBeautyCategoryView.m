//
//  RCSBeautyCategoryView.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import "RCSBeautyCategoryView.h"

@interface RCSBeautyCategoryView ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *sqLine;
@property (nonatomic, strong) NSArray<UIButton *> *categoryBtns;

@end

static NSInteger kSelectedCategoryViewTagMask = 1234;

@implementation RCSBeautyCategoryView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.offset(0);
        make.leading.trailing.inset(40);
    }];

    NSArray *titles = @[@"美肤", @"美型", @"滤镜"];
    NSMutableArray *btns = [NSMutableArray new];
    for (int i = 0; i < titles.count; i++) {
        UIButton *categoryBtn = [self createCategoryButtonWithTitle:titles[i]];
        categoryBtn.tag = kSelectedCategoryViewTagMask + i;

        [self.stackView addArrangedSubview:categoryBtn];
        [btns addObject:categoryBtn];
    }
    self.categoryBtns = [NSArray arrayWithArray:btns];

    [self addSubview:self.sqLine];
    [self.sqLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.offset(0);
        make.height.offset(0.5);
    }];
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
    for (UIButton *categoryBtn in self.categoryBtns) {
        categoryBtn.selected = NO;
    }
    btn.selected = !btn.isSelected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(toggleCategoryIndex:)]) {
        [self.delegate toggleCategoryIndex:btn.tag - kSelectedCategoryViewTagMask];
        _selectedIndex = btn.tag - kSelectedCategoryViewTagMask;
    }
}

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

@end
