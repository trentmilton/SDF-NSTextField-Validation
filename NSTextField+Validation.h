//
//  NSTextField+Validation.h
//
//  Created by Trent Milton on 04/07/2014.
//  Copyright (c) 2014 shaydes.dsgn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	TextFieldValidationTypeNone = 0, // Default
	TextFieldValidationTypeEmail,
	TextFieldValidationTypeEmailOptional,
	TextFieldValidationTypePassword,
	TextFieldValidationTypeRequired,
	TextFieldValidationTypeOptional
} TextFieldValidationType;

@interface NSTextField (Validation)

@property (nonatomic) TextFieldValidationType textFieldValidationType;
@property (nonatomic) NSString *placeholderString;

+ (void)setBackgroundColour:(NSColor *)colour;
+ (void)setValidBackgroundColour:(NSColor *)colour;
+ (void)setInvalidBackgroundColour:(NSColor *)colour;
+ (void)setPlaceholderValidateFontColour:(NSColor *)colour;
+ (void)setPlaceholderFontColour:(NSColor *)colour;

- (BOOL)validate;
- (void)reset;

@end
