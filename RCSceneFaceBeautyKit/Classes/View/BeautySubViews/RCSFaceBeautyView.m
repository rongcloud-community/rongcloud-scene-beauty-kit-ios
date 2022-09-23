//
//  RCSFaceBeautyView.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import "RCSFaceBeautyView.h"
#import "RCSBeautyButton.h"

@class RCSFaceBeautyCell;
@interface RCSFaceBeautyView () <UICollectionViewDelegate,
                                 UICollectionViewDataSource>

@property (nonatomic, strong) RCSBeautyButton *recoverBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *sqLine;

@end

@implementation RCSFaceBeautyView
- (instancetype)init {
    if (self = [super init]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.recoverBtn];
    [self.recoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(60);
        make.centerY.offset(0);
    }];
    
    [self addSubview:self.sqLine];
    [self.sqLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(24);
        make.top.offset(24);
        make.left.mas_equalTo(self.recoverBtn.mas_right).offset(14);
    }];

    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.left.mas_equalTo(self.recoverBtn.mas_right).offset(15);
    }];

    _selectedIndex = 0;
    [self setRecoverEnable:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= self.dataArray.count && selectedIndex >= 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    /// 滑动到之前设置的index
    dispatch_async(dispatch_get_main_queue(), ^{
          [self.collectionView scrollToItemAtIndexPath:indexPath
                                      atScrollPosition:UICollectionViewScrollPositionNone
                                              animated:NO];
    });
    
    _selectedIndex = selectedIndex;
    
}

- (void)setDataArray:(NSArray<RCSBeautyModel *> *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)recoverBtnClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceBeautyViewDidRecover:)]) {
        [self.delegate faceBeautyViewDidRecover:self];
    }
}

- (void)setRecoverEnable:(BOOL)enable {
    self.recoverBtn.alpha = enable ? 1.0 : 0.7;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSFaceBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCSFaceBeautyCell"
                                                                        forIndexPath:indexPath];
    RCSBeautyModel *model = self.dataArray[indexPath.row];
    
    NSString *imageName;
    UIColor *titleColor;
    BOOL opened = YES;
    if (model.isStyle101) {
        opened = fabs(model.value - 0.5) > 0.01;
    } else {
        opened = fabs(model.value - 0) > 0.01;
    }
    BOOL selected = _selectedIndex == indexPath.row;
    if (selected) {
        imageName = opened ? [model.title stringByAppendingString:@"-3"] : [model.title stringByAppendingString:@"-2"];
    } else {
        imageName = opened ? [model.title stringByAppendingString:@"-1"] : [model.title stringByAppendingString:@"-0"];
    }
    titleColor = _selectedIndex == indexPath.row ? RCSBeautyMainColor : [UIColor whiteColor];

    UIImage *imageIcon = [UIImage rcs_imageNamed:imageName bundle:@"RCSceneFaceBeautyKit"];
    cell.imageView.image = imageIcon;
    cell.titleLabel.text = model.title;
    cell.titleLabel.textColor = titleColor;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceBeautyView:didSelectedIndex:)]) {
        [self.delegate faceBeautyView:self didSelectedIndex:indexPath.row];
    }
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 22;
        flowLayout.minimumLineSpacing = 22;
        flowLayout.itemSize = CGSizeMake(44, 74);
        flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 6, 16);

        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:RCSFaceBeautyCell.class forCellWithReuseIdentifier:@"RCSFaceBeautyCell"];
    }
    return _collectionView;
}

- (RCSBeautyButton *)recoverBtn {
    if (!_recoverBtn) {
        _recoverBtn = [RCSBeautyButton new];
        [_recoverBtn setTitle:@"恢复" forState:UIControlStateNormal];
        [_recoverBtn setImage:RCSBeautyImageNamed(@"恢复-0") forState:UIControlStateNormal];
        [_recoverBtn addTarget:self
                        action:@selector(recoverBtnClicked)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _recoverBtn;
}

- (UIView *)sqLine {
    if (!_sqLine) {
        _sqLine = [UIView new];
        _sqLine.backgroundColor = [UIColor whiteColor];
        _sqLine.alpha = 0.2;
    }
    return _sqLine;
}

@end

@implementation RCSFaceBeautyCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = frame.size.width / 2.0;
        [self addSubview:self.imageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10,
                                                                    frame.size.width + 2,
                                                                    frame.size.width + 20,
                                                                    frame.size.height - frame.size.width - 2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;

        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
