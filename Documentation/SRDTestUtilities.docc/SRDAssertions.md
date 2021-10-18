# Assertions

Functions for asserting cases not covered by those provided by `XCTest`. 

## Overview

Although `XCTest` provides a wide variety of assertion functions that covers virtually every case, there are some edge cases that don't have a direct solution and would therefore require copying the code for asserting this edge cases to each test method where the assertion is needed. In lieu of repeatedly copying assertion code, the code is packaged into a number of distinct functions for the sake of simplicity and convenience.

## Topics

### Attributed Strings

- ``SRDAssertAttributedStringContainsAttribute(_:attribute:in:file:line:)-44ima``
- ``SRDAssertAttributedStringContainsAttribute(_:attribute:in:file:line:)-815ny``
- ``SRDAssertAttributedStringContainsAttribute(_:attribute:in:file:line:)-8jsk9``
- ``SRDAssertAttributedStringNotContainsAttribute(_:attribute:in:file:line:)``
