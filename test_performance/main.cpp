
#include "impl.h"
#include "vectorized.h"

void test_c_style_add(Index N)
{
    Scalar *a = new Scalar[N];
    Scalar *b = new Scalar[N];
    Scalar *c = new Scalar[N];

    for (Index i{0}; i < N; i++)
    {
        a[i] = i / 1000.0;
        b[i] = i / 1000.0;
    }
    cout << "Testing raw array impl\n";
    Timer t;
    t.start_counter();
    // add_c_style(a, b, c, N);
    add_c_style_simd(a, b, c, N);
    cout << t.get_elapsed_time() << endl;
    Index nn = N / 10;
    // for (Index i{0}; i < N; i++)
    // {
    //     if (i % nn == 0)
    //         cout << "c[" << i << "] = " << c[i] << endl;
    // }
    delete[] a;
    delete[] b;
    delete[] c;
}

void test_std_vector_add(Index N)
{
    cout << "Testing std vector impl\n";
    vector<Scalar> a(N), b(N), c(N);
    for (Index i{0}; i < N; i++)
    {
        a[i] = i / 1000.0;
        b[i] = i / 1000.0;
    }
    Timer t;
    t.start_counter();
    add_std_vector(a, b, c);
    string elapsed = t.get_elapsed_time();
    cout << t.get_elapsed_time() << endl;
}

void test_eigen_add(Index N)
{
    cout << "Testing eigen VectorX impl\n";
    VectorX a, b, c;
    a.resize(N);
    b.resize(N);
    c.resize(N);
    for (Index i{0}; i < N; i++)
    {
        a[i] = i / 1000.0;
        b[i] = i / 1000.0;
    }
    Timer t;
    t.start_counter();
    add_eigen_vector(a, b, c);
    string elapsed = t.get_elapsed_time();
    cout << t.get_elapsed_time() << endl;
}

void test_raw_small_matrix_add(Index rows, Index cols, Index N);
{
}

int main(int argc, char *argv[])
{
    cout << "Program compares various array operations\n";

    cout << "matrix addition:\n";
    Index N = 100000000;

    test_c_style_add(N);

    test_std_vector_add(N);

    test_eigen_add(N);

    cout << "---------------------------\n";
    cout << "Test multiple operations on small matrices\n";
}