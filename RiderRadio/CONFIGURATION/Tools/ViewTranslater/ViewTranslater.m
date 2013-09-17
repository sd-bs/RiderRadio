//
//  ViewTranslater.m
//  Kissbook
//
//  Created by Salomon BRYS <salomon@kickyourapp.com> on 22/03/12.
//  Copyright (c) 2012 Kick Your App. All rights reserved.
//


#import "ViewTranslater.h"


@implementation ViewTranslater

+ (void)translate:(UIView *)view {
    
    if ([view isKindOfClass:UILabel.class]) {
        UILabel *label = (UILabel*)view;
        label.text = NSLocalizedString(label.text, nil);
    }
    
    else if ([view isKindOfClass:UIButton.class]) {
        UIButton *button = (UIButton*)view;
        [button setTitle:NSLocalizedString([button titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
    }
    
    else if ([view isKindOfClass:UITextField.class]) {
        UITextField *textField = (UITextField*)view;
        textField.placeholder = NSLocalizedString(textField.placeholder, nil);
    }
    
    else if ([view isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView*)view;
        textView.text = NSLocalizedString(textView.text, nil);
    }
    
    for (UIView *subview in view.subviews)
        [self translate:subview];

}

@end
