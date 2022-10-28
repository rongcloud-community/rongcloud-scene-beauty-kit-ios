//
//  RCSStickerView.m
//  RCSceneFaceBeautyKit-RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSStickerView.h"
#import "RCSStickerCategoryView.h"
#import "RCSPanelStickerView.h"
#import "RCSStickerManager.h"

@interface RCSStickerView ()<RCSStickerCategoryViewDelegate, RCSPanelStickerViewDelegate>

@property (nonatomic, strong) RCSStickerCategoryView *categotyView;
@property (nonatomic, strong) NSMutableArray<RCSPanelStickerView *> *panels;

@end

@implementation RCSStickerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.categotyView];
    [self.categotyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.offset(0);
        make.bottom.offset(-20);
        make.height.mas_equalTo(42);
    }];
}

- (void)loadFullData:(NSArray<RCSStickerCategoryModel *> *)categories {
    if (categories.count == 0) {
        return;
    }
    
    NSArray<NSString *> *names = [categories valueForKeyPath:@"name"];
    [self.categotyView setTitles:names];
    self.categotyView.selectedIndex = 0;
        
    for (int i = 0; i<categories.count; i++) {
        RCSStickerCategoryModel *category = categories[i];
        RCSPanelStickerView *view = [[RCSPanelStickerView alloc] init];
        view.dataArray = category.data;
        view.delegate = self;
        view.hidden = (i != 0);
        [self addSubview:view];
        [self.panels addObject:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.top.offset(0);
            make.bottom.mas_equalTo(self.categotyView.mas_top).offset(0);
        }];
    }
}

#pragma mark - RCSStickerCategoryViewDelegate
- (void)toggleCategoryIndex:(NSInteger)index {
    for (int i = 0; i<self.panels.count; i++) {
        RCSPanelStickerView *view = self.panels[i];
        view.hidden = (i != index);
        [view reloadData];
    }
}

- (void)cancelSticker {
    if (self.delegate && [self.delegate respondsToSelector:@selector(releaseSticker)]) {
        [self.delegate releaseSticker];
    }
    
    NSUInteger currentIndex = self.categotyView.selectedIndex;
    RCSPanelStickerView *currentPanel = self.panels[currentIndex];
    [currentPanel reloadData];
}

#pragma mark - RCSPanelStickerViewDelegate
- (void)panelStickerView:(RCSPanelStickerView *)panel didSelectedIndex:(NSIndexPath *)indexPath {
    RCSStickerModel *currentModel = [RCSStickerManager shareManager].currentSelectedItem;
    RCSStickerModel *selectedModel = panel.dataArray[indexPath.row];
    if ([currentModel.itemId isEqualToString: selectedModel.itemId]) {
        return ;
    }
    
    selectedModel.loading = YES;
    [panel reloadDataWithIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(addStickerWithModel:complition:)]) {
        [self.delegate addStickerWithModel:panel.dataArray[indexPath.row] complition:^(BOOL success) {
            dispatch_main_async_safe(^{
                [panel reloadData];
            });
        }];
    }
}

#pragma mark - lazy load
- (NSMutableArray<RCSPanelStickerView *> *)panels {
    if (!_panels) {
        _panels = [NSMutableArray new];
    }
    return _panels;
}

- (RCSStickerCategoryView *)categotyView {
    if (!_categotyView) {
        _categotyView = [RCSStickerCategoryView new];
        _categotyView.delegate = self;
    }
    return _categotyView;
}

@end
