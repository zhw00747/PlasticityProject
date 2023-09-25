#pragma once
#include <immintrin.h>
using Scalar = double;
using Index = unsigned int;
void add_c_style_simd(const Scalar *a, const Scalar *b, Scalar *c, Index N);
