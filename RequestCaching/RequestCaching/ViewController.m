//
//  ViewController.m
//  RequestCaching
//
//  Created by Martin Berger on 3/16/17.
//  Copyright © 2017 heavydebugging.inc. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

@interface ViewController () <ViewModelDelegate>
@property (nonatomic, strong) ViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController

- (ViewModel*)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUIForDownloadState {
    [self.activityIndicator startAnimating];
    self.downloadButton.enabled = NO;
}

- (void)setupUIForNormalState {
    [self.activityIndicator stopAnimating];
    self.downloadButton.enabled = YES;
}

- (void)clearTextLabel {
    self.textLabel.text = @"";
}

- (void)setupUI {
    self.downloadButton.adjustsImageWhenDisabled = YES;
    
    self.downloadButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.downloadButton.layer.borderWidth = 1.0;
    self.clearButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.clearButton.layer.borderWidth = 1.0;
    self.textLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textLabel.layer.borderWidth = 1.0;
}

#pragma mark - Actions

- (IBAction)onDownload:(id)sender {
    [self setupUIForDownloadState];
    [self clearTextLabel];
    [self.viewModel download];
}

- (IBAction)onClear:(id)sender {
    [self clearTextLabel];
}

#pragma mark - ViewModelDelegate

- (void)viewModelDidFinish:(ViewModel*)viewModel text:(NSString*)text {
    self.textLabel.text = text;
    [self setupUIForNormalState];
}

@end
