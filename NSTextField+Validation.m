//
//  NSTextField+Validation.m
//
//  Created by Trent Milton on 02/07/2014.
//  Copyright (c) 2014 shaydes.dsgn. All rights reserved.
//

#import "NSTextField+Validation.h"
#import "NSString+Validate.h"
#import <objc/runtime.h>

static NSColor *kValidationTextFieldBackgroundColour;
static NSColor *kValidationTextFieldValidBackgroundColour;
static NSColor *kValidationTextFieldInvalidBackgroundColour;
static NSColor *kValidationTextFieldPlaceholderValidateFontColour;
static NSColor *kValidationTextFieldPlaceholderFontColour;

static void *TextFieldValidationTypePropertyKey = &TextFieldValidationTypePropertyKey;
static void *PlaceholderStringPropertyKey = &PlaceholderStringPropertyKey;

@implementation NSTextField (Validation)

+ (void)initialize
{
	if (self == [NSTextField class]) {
		kValidationTextFieldBackgroundColour = [NSColor whiteColor];
		kValidationTextFieldValidBackgroundColour = [NSColor greenColor];
		kValidationTextFieldInvalidBackgroundColour = [NSColor redColor];
		kValidationTextFieldPlaceholderValidateFontColour = [NSColor whiteColor];
		kValidationTextFieldPlaceholderFontColour = [NSColor grayColor];
	}
}

#pragma mark - Properties

- (TextFieldValidationType)textFieldValidationType
{
	NSNumber *t = objc_getAssociatedObject(self, TextFieldValidationTypePropertyKey);
	return t.intValue;
}

- (void)setTextFieldValidationType:(TextFieldValidationType)textFieldValidationType
{
	objc_setAssociatedObject(self, TextFieldValidationTypePropertyKey, @(textFieldValidationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)placeholderString
{
	return objc_getAssociatedObject(self, PlaceholderStringPropertyKey);
}

- (void)setPlaceholderString:(NSString *)placeholderString
{
	objc_setAssociatedObject(self, PlaceholderStringPropertyKey, placeholderString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (BOOL)validate
{
	NSColor *bgColour = kValidationTextFieldBackgroundColour;
	NSColor *placeholderColour = kValidationTextFieldPlaceholderValidateFontColour;

	BOOL valid = YES;
	switch (self.textFieldValidationType) {
		case TextFieldValidationTypeNone:
			// Do nothing, we just want white
			placeholderColour = kValidationTextFieldPlaceholderFontColour;
			break;

		case TextFieldValidationTypeEmailOptional:
			// IMPORTANT: make sure this is above the ValidationTypeEmail (which should be below)
			if (self.stringValue.length == 0) {
				// Do nothing, we just want white
				placeholderColour = kValidationTextFieldPlaceholderFontColour;
				break;
			}

		// Else: Do nothing, flow threw to ValidationTypeEmail

		case TextFieldValidationTypeEmail: {
			valid = [self.stringValue validEmail];
			bgColour = valid ? kValidationTextFieldValidBackgroundColour : kValidationTextFieldInvalidBackgroundColour;
			break;
		}

		case TextFieldValidationTypeOptional:
			placeholderColour = kValidationTextFieldPlaceholderFontColour;
			bgColour = kValidationTextFieldBackgroundColour;
			break;

		case TextFieldValidationTypeRequired:
		case TextFieldValidationTypePassword:
		default: {
			valid = self.stringValue.length > 0;
			bgColour = valid ? kValidationTextFieldValidBackgroundColour : kValidationTextFieldInvalidBackgroundColour;
			break;
		}
	}

	[self setPlaceholderFontColour:placeholderColour];

	self.backgroundColor = bgColour;
	// This will make sure the background updates
	[self setEditable:NO];
	[self setEditable:YES];

	return valid;
}

- (void)reset
{
	self.stringValue = @"";
	self.backgroundColor = kValidationTextFieldBackgroundColour;
	[self setPlaceholderFontColour:kValidationTextFieldPlaceholderFontColour];

	// This will make sure the background updates
	[self setEditable:NO];
	[self setEditable:YES];
}

#pragma mark - Private

- (void)setPlaceholderFontColour:(NSColor *)colour
{
	if (!self.placeholderString) {
		self.placeholderString = [self.cell placeholderString];
	}

	NSDictionary *d = @{
		NSFontAttributeName : self.font,
		NSForegroundColorAttributeName : colour
	};
	NSAttributedString *as = [[NSAttributedString alloc] initWithString:self.placeholderString
	                                                         attributes:d];
	[self.cell setPlaceholderAttributedString:as];
}

#pragma mark - Static Properties

+ (void)setBackgroundColour:(NSColor *)colour
{
	kValidationTextFieldBackgroundColour = colour;
}

+ (void)setValidBackgroundColour:(NSColor *)colour
{
	kValidationTextFieldValidBackgroundColour = colour;
}

+ (void)setInvalidBackgroundColour:(NSColor *)colour
{
	kValidationTextFieldInvalidBackgroundColour = colour;
}

+ (void)setPlaceholderValidateFontColour:(NSColor *)colour
{
	kValidationTextFieldPlaceholderValidateFontColour = colour;
}

+ (void)setPlaceholderFontColour:(NSColor *)colour
{
	kValidationTextFieldPlaceholderFontColour = colour;
}

@end
