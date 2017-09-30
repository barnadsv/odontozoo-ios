
//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  UIViewController+Alerts.h
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 29/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

#ifndef UIViewController_Alerts_h
#define UIViewController_Alerts_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*! @typedef AlertPromptCompletionBlock
 @brief The type of callback used to report text input prompt results.
 */
typedef void (^AlertPromptCompletionBlock)(BOOL userPressedOK, NSString *_Nullable userInput);

/*! @class Alerts
 @brief Wrapper for @c UIAlertController and @c UIAlertView for backwards compatability with
 iOS 6+.
 */
@interface UIViewController (Alerts)

/*! @fn showMessagePrompt:
 @brief Displays an alert with an 'OK' button and a message.
 @param message The message to display.
 */
- (void)showMessagePrompt:(NSString *)message;

/*! @fn showTextInputPromptWithMessage:completionBlock:
 @brief Shows a prompt with a text field and 'OK'/'Cancel' buttons.
 @param message The message to display.
 @param completion A block to call when the user taps 'OK' or 'Cancel'.
 */
- (void)showTextInputPromptWithMessage:(NSString *)message
                       completionBlock:(AlertPromptCompletionBlock)completion;

/*! @fn showSpinner
 @brief Shows the please wait spinner.
 @param completion Called after the spinner has been hidden.
 */
- (void)showSpinner:(nullable void (^)(void))completion;

/*! @fn hideSpinner
 @brief Hides the please wait spinner.
 @param completion Called after the spinner has been hidden.
 */
- (void)hideSpinner:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END


#endif /* UIViewController_Alerts_h */
