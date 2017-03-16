//
//  ViewModel.h
//  RequestCaching
//
//  Created by Martin Berger on 3/16/17.
//  Copyright © 2017 heavydebugging.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewModel;

@protocol ViewModelDelegate <NSObject>
- (void)viewModelDidFinish:(ViewModel*)viewModel text:(NSString*)text;
@end

@interface ViewModel : NSObject
@property (nonatomic, weak) id<ViewModelDelegate> delegate;
@property (nonatomic, strong, readonly) NSString* text;
- (void)download;
@end
