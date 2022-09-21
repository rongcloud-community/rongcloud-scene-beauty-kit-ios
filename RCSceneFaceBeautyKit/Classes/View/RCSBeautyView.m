//
//  RCSBeautyView.m
//  Pods-RCSceneFaceBeautyKit_Example
//
//  Created by 彭蕾 on 2022/9/15.
//

#import "RCSBeautyView.h"
#import "RCSFaceBeautyView.h"
#import "RCSFilterView.h"
#import "RCSBeautySlider.h"
#import "RCSBeautyModel.h"
#import "RCSBeautyCategoryView.h"
#import "RCSBeautyEngine.h"
#import "RCSBeautyEngine+Private.h"
#import "RCSBeautyManager.h"

#define RCSFUBeautifier [RCSBeautyManager shareManager].beautyModel

@interface RCSBeautyView () <RCSBeautyCategoryViewDelegate, RCSFilterViewDelegate, RCSFaceBeautyViewDelegate>

@property (nonatomic, strong) UIButton *compareBtn;
@property (nonatomic, strong) RCSBeautySlider *slider;

@property (nonatomic, strong) RCSFaceBeautyView *skinView;
@property (nonatomic, strong) RCSFaceBeautyView *shapeView;
@property (nonatomic, strong) RCSFilterView *filterView;
@property (nonatomic, strong) RCSBeautyCategoryView *categotyView;

/* 当前选中参数 */
@property (strong, nonatomic) RCSBeautyModel *selectedParam;

@end

@implementation RCSBeautyView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.compareBtn];
    [self.compareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(10);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    [self addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.compareBtn);
        make.left.mas_equalTo(self.compareBtn.mas_right).offset(16);
        make.right.mas_offset(-20);
    }];
    
    [self addSubview:self.skinView];
    [self.skinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.compareBtn.mas_bottom);
        make.height.mas_equalTo(98);
        make.leading.trailing.offset(0);
    }];
    
    [self addSubview:self.shapeView];
    [self.shapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.height.mas_equalTo(self.skinView);
    }];
    
    [self addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.height.mas_equalTo(self.skinView);
    }];
    
    [self addSubview:self.categotyView];
    [self.categotyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.top.mas_equalTo(self.skinView.mas_bottom);
        make.height.mas_equalTo(42);
    }];
}

#pragma mark - RCSBeautyCategoryViewDelegate

- (void)toggleCategoryIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            self.skinView.hidden = NO;
            self.shapeView.hidden = YES;
            self.filterView.hidden = YES;
            
            NSInteger selectedIndex = self.skinView.selectedIndex;
            if (selectedIndex < 0) {
                self.slider.hidden = YES;
            } else {
                self.slider.hidden = NO;
                [self setSelectedParam:self.skinView.dataArray[selectedIndex]];
            }
        }
            
            break;
        case 1: {
            self.skinView.hidden = YES;
            self.shapeView.hidden = NO;
            self.filterView.hidden = YES;
            
            NSInteger selectedIndex = self.shapeView.selectedIndex;
            if (selectedIndex < 0) {
                self.slider.hidden = YES;
            } else {
                self.slider.hidden = NO;
                [self setSelectedParam:self.shapeView.dataArray[selectedIndex]];
            }
        }
            
            break;
        case 2: {
            self.skinView.hidden = YES;
            self.shapeView.hidden = YES;
            self.filterView.hidden = NO;
            
            NSInteger selectedIndex = self.filterView.selectedIndex;
            if (selectedIndex <= 0) {
                self.slider.hidden = YES;
            } else {
                self.slider.hidden = NO;
                [self setSelectedParam:self.filterView.filters[selectedIndex]];
            }
        }
            
            break;
        default:
            break;
    }
}


#pragma mark - btn acitons
- (void)compareTouchDownAction {
    [[RCSBeautyEngine sharedInstance] setBeautyEnable:NO];
}

- (void)compareTouchUpAction {
    [[RCSBeautyEngine sharedInstance] setBeautyEnable:YES];
}

/// 滑条停止滑动
- (void)sliderChangeEnd:(RCSBeautySlider *)slider {
    switch (self.selectedParam.type) {
        case 0:
            [self.skinView setRecoverEnable:![[RCSBeautyManager shareManager] isDefaultValue:0]];
            break;
        case 1:
            [self.shapeView setRecoverEnable:![[RCSBeautyManager shareManager] isDefaultValue:1]];
            break;
        default:
            break;
    }
    
}

- (void)sliderValueChangedAction:(RCSBeautySlider *)slider {
    _selectedParam.value = slider.value * _selectedParam.ratio;
    switch (_selectedParam.type) {
        case 0:
            [[RCSBeautyEngine sharedInstance] setBeautySkin:_selectedParam.value forKey:_selectedParam.key];
            break;
        case 1:
            [[RCSBeautyEngine sharedInstance] setBeautyShape:_selectedParam.value forKey:_selectedParam.key];
            break;
        case 2:
            [[RCSBeautyEngine sharedInstance] setBeautyFilter:_selectedParam.value forKey:_selectedParam.key];
            break;
        default:
            break;
    }
}

- (void)setSelectedParam:(RCSBeautyModel *)selectedParam {
    _selectedParam = selectedParam;
    self.slider.value = _selectedParam.value / _selectedParam.ratio;
    [self sliderValueChangedAction:self.slider];
    self.slider.bidirection = _selectedParam.isStyle101;
}

#pragma mark - RCSFilterViewDelegate
- (void)filterViewDidSelectedIndex:(NSInteger)index {
    [RCSBeautyManager shareManager].filterChoice = index;
    self.selectedParam = RCSFUBeautifier.beautyFilters[index];
    self.slider.hidden = (index == 0);
}

#pragma mark - RCSFaceBeautyViewDelegate
- (void)faceBeautyView:(RCSFaceBeautyView *)view didSelectedIndex:(NSInteger)index {
    switch (view.type) {
        case 0:
            self.selectedParam = RCSFUBeautifier.beautySkins[index];
            break;
        case 1:
            self.selectedParam = RCSFUBeautifier.beautyShapes[index];
            break;
            
        default:
            break;
    }
    self.slider.hidden = NO;
}

- (void)faceBeautyViewDidRecover:(RCSFaceBeautyView *)view {
    if ([[RCSBeautyManager shareManager] isDefaultValue:view.type]) {
        return ;
    }
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil
                                                                      message:@"是否将所有参数恢复到默认值"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleAction setValue:[UIColor colorWithRed:44/255.0 green:46/255.0 blue:48/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self recoverBeautyWithType:view.type];
        [view setRecoverEnable:NO];
    }];
    [certainAction setValue:[UIColor colorWithRed:31/255.0 green:178/255.0 blue:255/255.0 alpha:1.0] forKey:@"titleTextColor"];
    
    [alertCon addAction:cancleAction];
    [alertCon addAction:certainAction];
    
    [[self viewController]  presentViewController:alertCon animated:YES completion:^{
    }];
}

- (void)recoverBeautyWithType:(int)type {
    switch (type) {
        case 0:
            [[RCSBeautyManager shareManager] resetBeautySkinValue];
            [self.skinView reloadData];
            self.selectedParam = RCSFUBeautifier.beautySkins[self.skinView.selectedIndex];
            break;
        case 1:
            [[RCSBeautyManager shareManager] resetBeautyShapeValue];
            [self.shapeView reloadData];
            self.selectedParam = RCSFUBeautifier.beautyShapes[self.shapeView.selectedIndex];
            break;
            
        default:
            break;
    }
}

#pragma mark - lazy load

- (RCSBeautyCategoryView *)categotyView {
    if (!_categotyView) {
        _categotyView = [RCSBeautyCategoryView new];
        _categotyView.delegate = self;
        _categotyView.selectedIndex = 0;
    }
    return _categotyView;
}

- (UIButton *)compareBtn {
    if (!_compareBtn) {
        _compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage rcs_imageNamed:@"icon_contrast" bundle:RCSBeautyBundleName];
        [_compareBtn setImage:RCSBeautyImageNamed(@"icon_contrast")
                     forState:UIControlStateNormal];
        
        [_compareBtn addTarget:self
                        action:@selector(compareTouchDownAction)
              forControlEvents:UIControlEventTouchDown];
        
        [_compareBtn addTarget:self
                        action:@selector(compareTouchUpAction)
              forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _compareBtn;
}

- (RCSFaceBeautyView *)skinView {
    if (!_skinView) {
        _skinView = [RCSFaceBeautyView new];
        _skinView.dataArray = RCSFUBeautifier.beautySkins;
        _skinView.backgroundColor = [UIColor blackColor];
        _skinView.delegate = self;
        _skinView.type = 0;
        _skinView.selectedIndex = [RCSBeautyManager shareManager].skinChoice;
        [_skinView setRecoverEnable:![[RCSBeautyManager shareManager] isDefaultValue:0]];
    }
    return _skinView;
}

- (RCSFaceBeautyView *)shapeView {
    if (!_shapeView) {
        _shapeView = [RCSFaceBeautyView new];
        _shapeView.dataArray = RCSFUBeautifier.beautyShapes;
        _shapeView.backgroundColor = [UIColor blackColor];
        _shapeView.delegate = self;
        _shapeView.type = 1;
        _shapeView.selectedIndex = [RCSBeautyManager shareManager].shapeChoice;
        [_shapeView setRecoverEnable:![[RCSBeautyManager shareManager] isDefaultValue:1]];
    }
    return _shapeView;
}

- (RCSFilterView *)filterView {
    if (!_filterView) {
        _filterView = [RCSFilterView new];
        _filterView.filters = RCSFUBeautifier.beautyFilters;
        _filterView.customDelegate = self;
        _filterView.backgroundColor = [UIColor blackColor];
        _filterView.selectedIndex = [RCSBeautyManager shareManager].filterChoice;
    }
    return _filterView;
}

- (RCSBeautySlider *)slider {
    if (!_slider) {
        _slider = [RCSBeautySlider new];
        
        [_slider addTarget:self
                    action:@selector(sliderValueChangedAction:)
          forControlEvents:UIControlEventValueChanged];
        
        [_slider addTarget:self
                    action:@selector(sliderChangeEnd:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

@end
