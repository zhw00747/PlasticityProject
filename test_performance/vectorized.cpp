#include "vectorized.h"

void add_c_style_simd(const Scalar *a, const Scalar *b, Scalar *c, Index N)
{
    for (Index i{0}; i < N; i++)
    {
        // c[i] = a[i] * b[i];
        __m256d va = _mm256_loadu_pd(&a[i]);
        __m256d vb = _mm256_loadu_pd(&b[i]);
        __m256d vc = _mm256_mul_pd(va, vb);
        _mm256_storeu_pd(&c[i], vc);
    }
}
