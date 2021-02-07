// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLModel (Difference)

/// Returns an array of strings describing the difference between the receiver and the given object.
/// When the receiver and the given object are equal an empty array is returned.
///
/// @note per convention the receiver is to be treated as the "expected",
/// while the argument object is the "actual".
- (NSArray<NSString *> *)differenceFrom:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
